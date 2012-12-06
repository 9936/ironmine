class Htc::CuxTicketsDetailList < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.enabled.
        with_category(I18n.locale).
        with_close_reason(I18n.locale).
        joins(" LEFT OUTER JOIN irm_roles_vl irv ON irv.id = #{Icm::IncidentRequest.table_name}.cux_organization_id AND irv.language = '#{I18n.locale}'").
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_priority(I18n.locale).
        with_external_system(I18n.locale).
        select("irv.name role_name").
        order("(#{Icm::IncidentRequest.table_name}.submitted_date) ASC")

    if params[:end_date].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
    else
      statis = statis.where("external_system.id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    datas = []
    headers = [
               I18n.t(:label_icm_incident_request_request_number),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_summary),
               I18n.t(:label_irm_external_system),
               I18n.t(:label_icm_incident_request_requested_by),
               I18n.t(:label_icm_incident_request_support_person),
               I18n.t(:label_icm_incident_request_cux_organization),
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_icm_incident_request_incident_sub_category),
               I18n.t(:label_icm_incident_request_incident_status_code),
               I18n.t(:label_icm_incident_request_submitted_date),
               I18n.t(:label_icm_incident_request_last_date),
               I18n.t(:label_icm_incident_request_cux_close_time),
               I18n.t(:label_icm_incident_request_cux_response_hours),
               I18n.t(:label_icm_incident_request_cux_resolve_hours),
               I18n.t(:label_icm_close_reason),
               I18n.t(:label_htc_report_incident_groups_history)
               ]

    statis.each do |s|
      data = Array.new(18)
      data[0] = s[:request_number]
      data[1] = s[:title]
      data[2] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
      data[3] = s[:external_system_name]
      data[4] = s[:requested_name]
      data[5] = s[:supporter_name]
      data[6] = s[:role_name]
      data[7] = s[:priority_name]
      data[8] = s[:incident_category_name]
      data[9] = s[:incident_sub_category_name]
      data[10] = s[:incident_status_name]
      data[11] = s[:submitted_date]
      data[12] = s[:last_response_date]
      # get close date
      last_close_journal = Icm::IncidentJournal.
                            where("incident_request_id = ?", s.id).
                            where("reply_type = ?", "CLOSE").
                            select("created_at").
                            order("created_at DESC").limit(1)
      if last_close_journal.any?
        data[13] = last_close_journal.first[:created_at]
        # (CloseDate is Null or CloseDate >= A)
        next if s.close? && Date.strptime("#{data[13]}", '%Y-%m-%d') < Date.strptime("#{params[:start_date]}", '%Y-%m-%d')
      else
        if s.close?
          data[13] = s[:last_response_date]
          next if Date.strptime("#{data[13]}", '%Y-%m-%d') < Date.strptime("#{params[:start_date]}", '%Y-%m-%d')
        else
          data[13] = ""
        end
      end

      data[14] = s[:cux_response_hours]
      data[15] = s[:cux_resolve_hours]
      data[16] = s[:close_reason_name]
      #get group history
      group_history = Icm::IncidentHistory.
                        joins(",icm_support_groups_vl isv").
                        where("isv.id = #{Icm::IncidentHistory.table_name}.new_value").
                        where("isv.language = ?", I18n.locale).
                        where("#{Icm::IncidentHistory.table_name}.request_id = ?", s.id).
                        where("#{Icm::IncidentHistory.table_name}.property_key = ?", "support_group_id").
                        select("isv.name group_his_name").
                        order("#{Icm::IncidentHistory.table_name}.created_at ASC")
      data[17] = ""
      group_history.each do |his|
        data[17] << his[:group_his_name]
        data[17] << "," if his != group_history.last
      end

      datas << data
    end

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