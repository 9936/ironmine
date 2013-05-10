# -*- coding:utf-8 -*-
class Hli::IncidentDetailBySolvedStatus < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    close_status = Icm::IncidentStatus.where("close_flag = ?", Irm::Constant::SYS_YES).first
    language = I18n.locale

    ex_attributes = []

    statis = Icm::IncidentRequest.
        select_all.
        enabled.
        with_category(I18n.locale).
        with_close_reason(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_supporter(I18n.locale).
        with_submitted_by.
        with_priority(I18n.locale).
        with_external_system(I18n.locale).
        order("(#{Icm::IncidentRequest.table_name}.submitted_date) ASC")

    type = params[:type]
    if type.eql?("CURRNEW")
      #本月接单数
      statis = statis.
          where("date_format(submitted_date, '%Y-%m') = ?", Date.strptime("#{params[:start][:year]}-#{params[:start][:month]}", '%Y-%m'))
    elsif type.eql?("CURRRESOLVED")
      #本月解决数
      statis = statis.
          where("EXISTS (SELECT * FROM icm_incident_journals ij WHERE ij.incident_request_id = icm_incident_requests.id AND ij.reply_type = ? AND date_format(ij.created_at, '%Y-%m') = ?)",
                "CLOSE", Date.strptime("#{params[:start][:year]}-#{params[:start][:month]}", '%Y-%m'))
    elsif type.eql?("PREUNSOLVED")
      #上月未解决数
      statis = statis.
          where("NOT EXISTS (SELECT * FROM icm_incident_journals ij WHERE ij.incident_request_id = icm_incident_requests.id AND ij.reply_type = ? AND date_format(ij.created_at, '%Y-%m') < ?)",
                "CLOSE", Date.strptime("#{params[:start][:year]}-#{params[:start][:month]}", '%Y-%m'))
    elsif type.eql?("CURRUNSOLVED")
      #本未解决数
      statis = statis.
          where("NOT EXISTS (SELECT * FROM icm_incident_journals ij WHERE ij.incident_request_id = icm_incident_requests.id AND ij.reply_type = ? AND date_format(ij.created_at, '%Y-%m') <= ?)",
                "CLOSE", Date.strptime("#{params[:start][:year]}-#{params[:start][:month]}", '%Y-%m'))
    end

    if params[:hotline].present?
      statis = statis.where("icm_incident_requests.hotline = ?", params[:hotline])
    end

    bo = Irm::BusinessObject.where("business_object_code = ?", "ICM_INCIDENT_REQUESTS").first

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
      if params[:external_system_id].present? && params[:external_system_id].size == 1
        ex_attributes = Irm::ObjectAttribute.multilingual.enabled.
            where("business_object_id = ?", bo.id).
            where("field_type = ?", "GLOBAL_CUX_FIELD").order("display_sequence ASC")
      end
    else
      current_acc_systems = Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id)

      puts("+++++++++++++++++++++++++++++++ systems" + current_acc_systems.to_json)
      statis = statis.where("external_system.id IN (?)", current_acc_systems + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
      if current_acc_systems.present? && current_acc_systems.size == 1
        ex_attributes = Irm::ObjectAttribute.multilingual.enabled.
            where("business_object_id = ?", bo.id).
            where("field_type = ?", "GLOBAL_CUX_FIELD").order("display_sequence ASC")
      end
    end


    datas = []
    headers = [
               I18n.t(:label_icm_incident_request_request_number),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_summary),
               I18n.t(:label_irm_external_system),
               I18n.t(:label_icm_incident_request_requested_by),
               I18n.t(:label_icm_incident_request_submitted_by),
               I18n.t(:label_icm_incident_request_support_person),
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_icm_incident_request_incident_sub_category),
               I18n.t(:label_icm_incident_request_incident_status_code),
               I18n.t(:label_icm_incident_request_submitted_date),
               I18n.t(:label_icm_incident_request_last_date),
               I18n.t(:label_icm_incident_request_estimated_date),
               I18n.t(:label_icm_incident_journal_close_date),
               I18n.t(:label_icm_close_reason)
               ]

    ex_attributes.each do |ea|
      headers << ea[:name]
    end


    statis.each do |s|
      data = Array.new(16 + ex_attributes.size)
      data[0] = s[:request_number]
      data[1] = s[:title]
      data[2] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
      data[3] = s[:external_system_name]
      data[4] = s[:requested_name]
      data[5] = s[:submitted_name]
      data[6] = s[:supporter_name]
      data[7] = s[:priority_name]
      data[8] = s[:incident_category_name]
      data[9] = s[:incident_sub_category_name]
      data[10] = s[:incident_status_name]
      data[11] = s[:submitted_date]
      data[12] = s[:last_response_date]
      data[13] = s[:estimated_date]
      # get close date
      last_close_journal = Icm::IncidentJournal.
                            where("incident_request_id = ?", s.id).
                            where("reply_type = ?", "CLOSE").
                            select("created_at").
                            order("created_at DESC").limit(1)
      if last_close_journal.any?
        data[14] = last_close_journal.first[:created_at]
      else
        if s.close?
          data[14] = s[:last_response_date]
        else
          data[14] = ""
        end
      end
      data[15] = s[:close_reason_name]

      nc = 16
      ex_attributes.each do |ea|
        data[nc] = s[ea[:attribute_name].to_sym]
        nc = nc + 1
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