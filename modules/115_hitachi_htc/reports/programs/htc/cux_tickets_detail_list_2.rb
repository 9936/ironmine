class Htc::CuxTicketsDetailList2 < Irm::ReportManager::ReportBase
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
               I18n.t(:label_htc_report_incident_requester_group),
               I18n.t(:label_htc_report_incident_groups_history),"Root Cause"
               ]

    ex_attributes.each do |ea|
      headers << ea[:name]
    end

    start_date = params[:start_date]
    unless params[:start_date].present?
       start_date = "1970-1-1"
    end 

    end_date = params[:end_date]
    unless params[:end_date].present?
      end_date = "2099-1-1"
    end

    statis.each do |s|
      data = Array.new(20 + ex_attributes.size)
      data[0] = s[:request_number]
      data[1] = s[:title]
      data[2] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
      data[3] = s[:external_system_name]
      data[4] = s[:requested_name]
      data[5] = s[:supporter_name]
      data[6] = s[:attribute2]
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
        next unless s.close? &&
            Date.strptime("#{data[13]}", '%Y-%m-%d') >= Date.strptime("#{start_date}", '%Y-%m-%d') &&
            Date.strptime("#{data[13]}", '%Y-%m-%d') <= Date.strptime("#{end_date}", '%Y-%m-%d')
      else
        next
      end

      data[14] = s[:cux_response_hours]
      data[15] = s[:cux_resolve_hours]
      data[16] = s[:close_reason_name]

      data[17] = ""
      if s.requested_by.present?
        pt = Irm::Person.find(s.requested_by)
        gp = pt.groups.multilingual.enabled.collect{|p| p[:name]}
        gp.uniq!
        data[17] = pt.full_name + "\\" + gp.join(",") if gp && gp.size > 0
      end

      #get replied person groups
      persons = Icm::IncidentJournal.where("incident_request_id = ?", s.id).
                where("reply_type IN ('SUPPORTER_REPLY', 'OTHER_REPLY', 'CUSTOMER_REPLY')").
                enabled.
                order("created_at ASC").collect(&:replied_by)
      persons.uniq! if persons
      g = []
      persons.each do |p|
        pt = Irm::Person.find(p)
        gp = pt.groups.multilingual.
            where(" EXISTS(SELECT 1 FROM icm_support_groups isg WHERE isg.group_id = irm_groups.id AND isg.oncall_flag = ?)", "Y").
            enabled.collect{|p| p[:name]}
        gp.uniq!
        g << pt.full_name + "\\" + gp.join(",") + "\r\n" if gp && gp.size > 0
      end if persons
      #get watchers group
      s.watcher_person_ids.each do |w|
        pt = Irm::Person.find(w)
        gp = pt.groups.multilingual.
            where(" EXISTS(SELECT 1 FROM icm_support_groups isg WHERE isg.group_id = irm_groups.id AND isg.oncall_flag = ?)", "Y").
            enabled.collect{|p| p[:name]}
        gp.uniq!
        g << pt.full_name + "\\" + gp.join(",") + "\r\n" if gp && gp.size > 0
      end
      if s.support_person_id.present?
        pt = Irm::Person.find(s.support_person_id)
        gp = pt.groups.multilingual.
            where(" EXISTS(SELECT 1 FROM icm_support_groups isg WHERE isg.group_id = irm_groups.id AND isg.oncall_flag = ?)", "Y").
        enabled.collect{|p| p[:name]}
        gp.uniq!
        g << pt.full_name + "\\" + gp.join(",") + "\r\n" if gp && gp.size > 0
      end
      g.flatten!
      g.uniq!
      data[18] = g.join(" | ")
      data[19] = s[:attribute1]
      nc = 20
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
