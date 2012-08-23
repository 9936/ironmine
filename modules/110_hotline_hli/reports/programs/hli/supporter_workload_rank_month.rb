class Hli::SupporterWorkloadRankMonth < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    hotline_time = Irm::Person.where("login_name = ?", "hotline_time").first
    ranking_size = 5
    close_status = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES).first
    supporters = Irm::Person.
        enabled.
        select("#{Irm::Person.table_name}.*").
        where("#{Irm::Person.table_name}.login_name <> ?", "hotline_time").
        where(%Q"EXISTS(SELECT * FROM #{Icm::SupportGroup.table_name} sg, #{Irm::GroupMember.table_name} gm
                 WHERE sg.group_id = gm.group_id
                 AND gm.person_id = #{Irm::Person.table_name}.id
                 AND sg.oncall_flag = ?)", Irm::Constant::SYS_YES)

    statis = Icm::IncidentRequest.where("hotline = ?", Irm::Constant::SYS_YES).enabled

    statis = statis.
        select(%Q(
                (SELECT
                      count(1) current_person_time
                  FROM
                      icm_incident_workloads iw1
                  WHERE
                      iw1.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND iw1.real_processing_time > 0
                  AND iw1.person_id = iw.person_id) current_person_time
               )).
        select(%Q(
                (SELECT
                      count(1) total_time
                  FROM
                      icm_incident_workloads iw2
                  WHERE iw2.person_id <> '#{hotline_time.id}' AND
                      iw2.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND iw2.real_processing_time > 0) total_time
               )).
        select("iw.person_id handle_supporter_id, #{Icm::IncidentRequest.table_name}.id incident_request_id").
        joins(", icm_incident_workloads iw").
        where("#{Icm::IncidentRequest.table_name}.id = iw.incident_request_id").
        where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?", close_status.id).
        where("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m-%d') < ?", Date.strptime("#{params[:to_year][:year]}-#{params[:to_year][:month]}", '%Y-%m') + 1.month).
        where("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:from_year][:year]}-#{params[:from_year][:month]}", '%Y-%m'))

    sum_statis = Icm::IncidentRequest.enabled.
        where("hotline = ?", Irm::Constant::SYS_YES).
        where("incident_status_id = ?", close_status.id).
        select("count(1) sum_statis").
        where("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m-%d') < ?", Date.strptime("#{params[:to_year][:year]}-#{params[:to_year][:month]}", '%Y-%m') + 1.month).
        where("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:from_year][:year]}-#{params[:from_year][:month]}", '%Y-%m'))

    #if params[:from_year].present? && params[:to_year].present?
    #  close_statuses = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES).collect(&:incident_status_code)
    #  #必须是在所选时间范围内有关闭动作的事故单
    #  sum_statis = sum_statis.where(%Q(EXISTS (SELECT * FROM #{Icm::IncidentJournal.table_name} ij
    #                      WHERE ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id
    #                      AND ij.reply_type IN (?)
    #                      AND date_format(ij.created_at, '%Y-%m-%d') < ?
    #                      AND date_format(ij.created_at, '%Y-%m-%d') >= ?)),
    #                              close_statuses + [''],
    #                              Date.strptime("#{params[:to_year][:year]}-#{params[:to_year][:month]}", '%Y-%m') + 1.month,
    #                              Date.strptime("#{params[:from_year][:year]}-#{params[:from_year][:month]}", '%Y-%m'))
    #  statis = statis.where(%Q(EXISTS (SELECT * FROM #{Icm::IncidentJournal.table_name} ij
    #                WHERE ij.incident_request_id = #{Icm::IncidentRequest.table_name}.id
    #                AND ij.reply_type IN (?)
    #                AND date_format(ij.created_at, '%Y-%m-%d') < ?
    #                AND date_format(ij.created_at, '%Y-%m-%d') >= ?)),
    #                        close_statuses + [''],
    #                        Date.strptime("#{params[:to_year][:year]}-#{params[:to_year][:month]}", '%Y-%m') + 1.month,
    #                        Date.strptime("#{params[:from_year][:year]}-#{params[:from_year][:month]}", '%Y-%m'))
    #end

    datas = []
    headers = [I18n.t(:label_report_rank),
               I18n.t(:label_irm_person_name),
               I18n.t(:label_amount),
               I18n.t(:label_report_share)]

    #total_size = statis.size
    sum_statis = sum_statis.first
    supporters.each do |sp|
      data = Array.new(4)
      data[2] = 0
      data[3] = "0%"
      statis.where("iw.person_id = ?", sp.id).each do |st|
        data[1] = sp[:first_name]
        data[2] = data[2] + (st[:current_person_time].to_f/st[:total_time] *100).round/100.to_f
      end
      data[3] = ((data[2].to_f/sum_statis[:sum_statis].to_f * 100 * 100).round / 100.0).to_f.to_s + "%" unless sum_statis[:sum_statis] == 0
      next if data[1].blank?
      datas << data
    end
    datas.sort! { |a,b| b[2] <=> a[2] }
    #datas = datas[0..(ranking_size - 1)]
    #0.upto(ranking_size - 1) do |index|
    0.upto(datas.size - 1) do |index|
      break if index >= datas.size
      datas[index][0] = index + 1
    end unless datas.blank?
    {:datas=>datas,:headers=>headers,:params=>params}
  end

  def to_xls(params)
    columns = []

    result = data(params)

    result[:headers].each_with_index do |sh,index|
      columns << {:key=>index.to_s.to_sym,:label=>sh}
    end

    excel_data = []
    result[:datas].each_with_index do |data,index|
      excel_data << data.to_cus_hash
    end

    excel_data.to_xls(columns,{})
  end
end