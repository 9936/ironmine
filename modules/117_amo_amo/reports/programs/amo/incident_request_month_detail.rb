# -*- coding:utf-8 -*-
class Amo::IncidentRequestMonthDetail < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.
        enabled.
        with_workloads.
        with_category(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_contact.
        with_submitted_by.
        with_supporter(I18n.locale).
        with_priority(I18n.locale).
        with_urgence(I18n.locale).
        with_impact_range(I18n.locale).
        with_external_system(I18n.locale).order("(#{Icm::IncidentRequest.table_name}.request_number + 0) ASC")

    if params[:start_date].present? && params[:end_date].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    if params[:hotline].present?
      statis = statis.where("icm_incident_requests.hotline = ?", params[:hotline])
    end

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
    else
      statis = statis.where("external_system.id IN (?)", Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end

    datas = []
    headers = ["インシデント番号",
               "タイトル",
               "インシデント依頼カテゴリー",
               "サブカテゴリ",
               I18n.t(:label_project),
               "依頼者",
               "連絡者",
               "レポーター",
               "ステータス",
               "登録日",
               "対応完了希望日",
               "緊急度",
               "代替手段有無",
               "優先度",
               "サポーター",
               "工数",
               "概要",
               I18n.t(:label_report_request_last_updated),
               I18n.t(:label_icm_incident_request_contact_way),
               I18n.t(:label_icm_incident_request_client_info)
               ]
    headers << I18n.t(:label_report_incident_request_journal) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)

    statis.each do |s|
      data = Array.new(20)
      data = Array.new(21) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
      data[0] = s[:request_number]
      data[1] = s[:title]
      data[2] = s[:incident_category_name]
      data[3] = s[:incident_sub_category_name]
      data[4] = s[:external_system_name]
      data[5] = s[:requested_name]
      data[6] = s[:contact_name]
      data[7] = s[:submitted_name]
      data[8] = s[:incident_status_name]
      data[9] = s[:submitted_date].strftime('%F %T')
      data[10] = s[:estimated_date].strftime('%F %T')
      data[11] = s[:impact_range_name]
      data[12] = s[:report_source_name]
      data[13] = s[:priority_name]
      data[14] = s[:supporter_name]
      data[15] = s[:total_processing_time]
      data[16] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
      data[17] = s[:last_response_date].strftime('%F %T')
      data[18] = s[:contact_number]
      data[19] = s[:client_info]
      if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
        messages = ''
        messages << s.concat_journals_with_text
        messages = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(messages,""))
        data[20] = messages
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