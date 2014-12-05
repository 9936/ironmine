# -*- coding:utf-8 -*-
class Cpi::IncidentRequestMonthDetailAdmin < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.enabled.
        with_category(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_contact.
        with_supporter(I18n.locale).with_support_group(I18n.locale).
        with_priority(I18n.locale).
        with_external_system(I18n.locale).order("(#{Icm::IncidentRequest.table_name}.request_number + 0) ASC")

    start_date = '1970-01-01'
    start_date = params[:start_date] if params[:start_date].present?
    end_date = '2099-01-01'
    end_date = params[:end_date] if params[:end_date].present?

    statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') >= ?", Date.strptime("#{start_date}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?", Date.strptime("#{end_date}", '%Y-%m-%d').strftime("%Y-%m-%d"))

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
    else
      statis = statis.where("external_system.id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    datas = []
    headers = [I18n.t(:label_report_number),
               I18n.t(:label_project),
               I18n.t(:label_reporter),
               I18n.t(:label_report_incident_request_support),
               "支持组",
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_icm_incident_request_incident_sub_category),
               I18n.t(:label_report_request_submit_date),
               I18n.t(:label_report_request_last_updated),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_summary),
               I18n.t(:label_icm_incident_request_contact),
               I18n.t(:label_icm_incident_request_contact_way),
               I18n.t(:label_icm_incident_request_client_info),
               I18n.t(:label_icm_incident_request_incident_status_code),
               "First Assign"
               ]
    headers << I18n.t(:label_report_incident_request_journal) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)

    statis.each do |s|
      data = Array.new(17)
      data = Array.new(18) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
      data[0] = s[:request_number]
      data[1] = s[:external_system_name]
      data[2] = s[:requested_name]
      data[3] = s[:supporter_name]
      data[4] = s[:support_group_name]
      data[5] = s[:priority_name]
      data[6] = s[:incident_category_name]
      data[7] = s[:incident_sub_category_name]
      data[8] = s[:submitted_date].strftime('%F %T')
      data[9] = s[:last_response_date].strftime('%F %T')
      data[10] = s[:title]
      data[11] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
      data[12] = s[:contact_name]
      data[13] = s[:contact_number]
      data[14] = s[:client_info]
      data[15] = s[:incident_status_name]
      #get first assign
      first_assign_journal = Icm::IncidentJournal.
          where("incident_request_id = ?", s.id).
          where("reply_type = ?", "ASSIGN").
          select("created_at").
          order("created_at ASC").limit(1)
      if first_assign_journal.any?
        data[16] = first_assign_journal.first[:created_at].strftime("%F %T")
      else
        data[16] = ""
      end
      if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
        messages = ''
        messages << s.concat_journals_with_text
        messages = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(messages,""))
        data[17] = messages
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