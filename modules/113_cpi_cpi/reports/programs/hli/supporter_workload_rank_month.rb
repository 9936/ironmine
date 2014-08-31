# -*- coding:utf-8 -*-
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
                      SUM(iw1.real_processing_time)
                  FROM
                      icm_incident_workloads iw1
                  WHERE
                      iw1.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND iw1.real_processing_time > 0
                  AND iw1.person_id = iw.person_id) current_person_time
               )).
        select(%Q(
                (SELECT
                      SUM(iw2.real_processing_time)
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
        joins(",icm_incident_workloads iw").
        select("SUM(iw.real_processing_time) sum_statis").
        where("iw.incident_request_id = #{Icm::IncidentRequest.table_name}.id").
        where("hotline = ?", Irm::Constant::SYS_YES).
        where("incident_status_id = ?", close_status.id).
        #select("count(1) sum_statis").
        where("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m-%d') < ?", Date.strptime("#{params[:to_year][:year]}-#{params[:to_year][:month]}", '%Y-%m') + 1.month).
        where("date_format(#{Icm::IncidentRequest.table_name}.last_response_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:from_year][:year]}-#{params[:from_year][:month]}", '%Y-%m'))

    sum_ticket_statis = Icm::IncidentRequest.enabled.
        select("COUNT(1) sum_tickets").
        where("hotline = ?", Irm::Constant::SYS_YES).
        where("incident_status_id = ?", close_status.id).
        #select("count(1) sum_statis").
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
               "工时总数(小时)",
               "工时" + I18n.t(:label_report_share),
               I18n.t(:label_amount) + "(每单按工时比例分割)",
               "按工时比例平均每单耗时(小时)", "最后支持关闭单数", "按最后关闭平均每单耗时(小时)"]

    #total_size = statis.size
    sum_statis = sum_statis.first
    supporters.each do |sp|
      data = Array.new(8)
      data[4] = 0
      data[2] = 0
      data[3] = "0%"
      st_total_time = 0
      statis.where("iw.person_id = ?", sp.id).each do |st|
        data[1] = sp[:first_name]
        data[4] = data[4] + (st[:current_person_time].to_f/st[:total_time].to_f).round(2)
        st_total_time = st_total_time +  st[:current_person_time]
      end
      data[4] = data[4].round(2)
      #data[3] = ((data[2].to_f/sum_statis[:sum_statis].to_f * 100 * 100).round / 100.0).to_f.to_s + "%" unless sum_statis[:sum_statis] == 0
      data[2] = st_total_time.round(2)
      data[3] = (st_total_time.to_f/sum_statis[:sum_statis].to_f * 100).round(2).to_s + "%" unless sum_statis[:sum_statis] == 0
      data[5] = (data[2]/data[4]).round(2)
      begin
        sum_tickets = sum_ticket_statis.where("support_person_id = ?", sp.id).first[:sum_tickets]
      rescue
        sum_tickets = 0
      end
      data[6] = sum_tickets
      if data[6] == 0
        data[7] = "X"
      else
        data[7] = (data[2]/data[6].to_f).round(2)
      end
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