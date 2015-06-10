# -*- coding:utf-8 -*-
class Ysq::CuxTicketsDetailWithSla < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.enabled.
        with_category(I18n.locale).
        with_close_reason(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_support_group(I18n.locale).
        with_supporter(I18n.locale).
        with_priority(I18n.locale).
        with_urgence(I18n.locale).
        with_impact_range(I18n.locale).
        with_report_source(I18n.locale).
        with_external_system(I18n.locale).
        select("(SELECT COUNT(1) FROM icm_incident_histories iihh WHERE iihh.property_key = 'support_group_id' AND iihh.new_value <> '000Q00091nxNqRI7bBNZXU' AND iihh.request_id = #{Icm::IncidentRequest.table_name}.id) no_sd").
        select("(SELECT ssi1.id FROM slm_sla_instances ssi1, slm_service_agreements_vl ssav1 WHERE ssav1.id = ssi1.service_agreement_id AND ssi1.bo_id = #{Icm::IncidentRequest.table_name}.id AND ssav1.name = '【問合せ】受付遵守率' AND ssav1.external_system_id = #{Icm::IncidentRequest.table_name}.external_system_id ORDER BY ssi1.created_at DESC LIMIT 1) sf").
        select("(SELECT ssi2.id FROM slm_sla_instances ssi2, slm_service_agreements_vl ssav2 WHERE ssav2.id = ssi2.service_agreement_id AND ssi2.bo_id = #{Icm::IncidentRequest.table_name}.id AND ssav2.name = '【問合せ】回答所要時間' AND ssav2.external_system_id = #{Icm::IncidentRequest.table_name}.external_system_id ORDER BY ssi2.created_at DESC LIMIT 1) hd").
        select("              (SELECT
                      distinct ircg.name
                  FROM
                      irm_rating_config_grades ircg,
                      irm_ratings irt
                  WHERE
                      irt.rating_object_id = #{Icm::IncidentRequest.table_name}.id
                          AND irt.grade = ircg.grade
                          AND ircg.rating_config_id = '004M00091pvgVjGtZKQowS') `rating`").
        order("(#{Icm::IncidentRequest.table_name}.submitted_date) ASC")

    if params[:end_date].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    ex_attributes = []
    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
      if params[:external_system_id].present? && params[:external_system_id].size == 1
        ex_attributes = Irm::ObjectAttribute.multilingual.enabled.
            where("external_system_id = ?", params[:external_system_id][0]).
            where("field_type = ?", "SYSTEM_CUX_FIELD").order("display_sequence ASC")
      end
    else
      current_acc_systems = Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id)
      statis = statis.where("external_system.id IN (?)", current_acc_systems + []) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
      if current_acc_systems.present? && current_acc_systems.size == 1
        ex_attributes = Irm::ObjectAttribute.multilingual.enabled.
            where("external_system_id = ?", params[:external_system_id][0]).
            where("field_type = ?", "SYSTEM_CUX_FIELD").order("display_sequence ASC")
      end
    end

    datas = []


    headers = [
               I18n.t(:label_icm_incident_request_request_number),
               I18n.t(:label_icm_incident_request_title),
               I18n.t(:label_icm_incident_request_summary),
               I18n.t(:label_irm_external_system),
               I18n.t(:label_icm_incident_request_requested_by),
               I18n.t(:label_icm_incident_request_support_person),
               I18n.t(:label_icm_incident_request_support_group),
               I18n.t(:label_icm_incident_request_priority),
               I18n.t(:label_icm_incident_request_incident_category),
               I18n.t(:label_icm_incident_request_incident_sub_category),
               I18n.t(:label_icm_incident_request_incident_status_code),
               I18n.t(:label_icm_incident_request_submitted_date),
               I18n.t(:label_icm_incident_request_estimated_date),
               I18n.t(:label_icm_incident_request_last_date),
               I18n.t(:label_icm_incident_journal_close_date),
               I18n.t(:label_icm_close_reason),
               I18n.t(:label_icm_urgency_name),
               I18n.t(:label_icm_impact_range),
               I18n.t(:label_icm_incident_request_report_source_code),
               "【問合せ】受付遵守率",
               "【問合せ】回答所要時間",
               "SD Only","Rating"
               ]

    ex_attributes.each do |ea|
      headers << ea[:name]
    end

    start_date = params[:start_date]
    unless params[:start_date].present?
       start_date = "1970-1-1"
    end 
   
    statis.each do |s|
      data = Array.new(23 + ex_attributes.size)
      data[0] = s[:request_number]
      data[1] = s[:title]
      data[2] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
      data[3] = s[:external_system_name]
      data[4] = s[:requested_name]
      data[5] = s[:supporter_name]
      data[6] = s[:support_group_name]
      data[7] = s[:priority_name]
      data[8] = s[:incident_category_name]
      data[9] = s[:incident_sub_category_name]
      data[10] = s[:incident_status_name]
      data[11] = s[:submitted_date]
      data[12] = s[:estimated_date]
      data[13] = s[:last_response_date]
      # get close date
      last_close_journal = Icm::IncidentJournal.
                            where("incident_request_id = ?", s.id).
                            where("reply_type = ?", "CLOSE").
                            select("created_at").
                            order("created_at DESC").limit(1)
      if last_close_journal.any?
        data[14] = last_close_journal.first[:created_at]
        # (CloseDate is Null or CloseDate >= A)
        next if s.close? && Date.strptime("#{data[14]}", '%Y-%m-%d') < Date.strptime("#{start_date}", '%Y-%m-%d')
      else
        if s.close?
          data[14] = s[:last_response_date]
          next if Date.strptime("#{data[14]}", '%Y-%m-%d') < Date.strptime("#{start_date}", '%Y-%m-%d')
        else
          data[14] = ""
        end
      end
      data[15] = s[:close_reason_name]
      data[16] = s[:urgence_name]
      data[17] = s[:impact_range_name]
      data[18] = s[:report_source_name]
      data[19] = ""
      if s[:sf].present?
        si = Slm::SlaInstance.find(s[:sf])
        if !si.current_status.eql?("RUNNING")
          data[19] = "#{si.current_duration.to_s}/#{si.max_duration.to_s}"
        else
          data[19] = "#{si.current_duration.to_i+si.working_time(si.service_agreement,si.last_phase_start_date,Time.now)}/#{si.max_duration.to_s}"
        end
      end
      data[20] = ""
      if s[:hd].present?
        si = Slm::SlaInstance.find(s[:hd])
        if !si.current_status.eql?("RUNNING")
          data[20] = "#{si.current_duration.to_s}/#{si.max_duration.to_s}"
        else
          data[20] = "#{si.current_duration.to_i+si.working_time(si.service_agreement,si.last_phase_start_date,Time.now)}/#{si.max_duration.to_s}"
        end
      end
      data[21] = s[:no_sd].to_i > 0 ? 'N' : 'Y'
      data[22] = s[:rating]
      nc = 23
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
