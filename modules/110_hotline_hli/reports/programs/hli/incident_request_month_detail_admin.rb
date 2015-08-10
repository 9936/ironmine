# -*- coding:utf-8 -*-
class Hli::IncidentRequestMonthDetailAdmin < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}

    statis = Icm::IncidentRequest.
        select_all.select("#{Icm::IncidentRequest.table_name}.attribute6 charging_time").enabled.with_workloads.with_workloads_remote.with_workloads_scene.
        with_category(I18n.locale).
        with_requested_by(I18n.locale).
        with_incident_status(I18n.locale).
        with_contact.
        with_supporter(I18n.locale).
        with_priority(I18n.locale).
        with_external_system(I18n.locale).order("(#{Icm::IncidentRequest.table_name}.request_number + 0) ASC")

    if params[:start_date].present? && params[:end_date].present?
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
      statis = statis.where("date_format(icm_incident_requests.submitted_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    if params[:close_start_date].present? && params[:close_end_date].present?
      statis = statis.where("date_format(icm_incident_requests.last_response_date, '%Y-%m-%d') >= ?", Date.strptime("#{params[:close_start_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
      statis = statis.where("date_format(icm_incident_requests.last_response_date, '%Y-%m-%d') <= ?", Date.strptime("#{params[:close_end_date]}", '%Y-%m-%d').strftime("%Y-%m-%d"))
    end

    if params[:hotline].present?
      statis = statis.where("icm_incident_requests.hotline = ?", params[:hotline])
    end

    #定义system数组
    sys_data = []

    if params[:external_system_id].present? && params[:external_system_id].size > 0 && params[:external_system_id][0].present?
      sys_data = params[:external_system_id] + []
      statis = statis.where("external_system.id IN (?)", params[:external_system_id] + [])
    else
      sys_data = (Irm::ExternalSystem.multilingual.order_with_name.with_person(params[:running_person_id]).enabled.collect(&:id) + [])
      statis = statis.where("external_system.id IN (?)", sys_data) unless Irm::Person.where("login_name = ?",'anonymous').where("id = ?", params[:running_person_id]).any?
    end


    datas = []
    headers = [I18n.t(:label_report_number),
               I18n.t(:label_project),
               I18n.t(:label_reporter),
               I18n.t(:label_report_incident_request_support),
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
               I18n.t(:label_report_request_workload),"远程工时","现场工时",
               "First Assign","Out of SLA","用户打分","Charging Time"
               ]
    headers << I18n.t(:label_report_incident_request_journal) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)

    # 标题行 给 IEB AMO 添加自定义字段显示 English description
    sys_data.each do |sys|
      if sys.eql?('000q00040ldeyhJAU9f5km')
        headers << "English description"
      end
    end


    statis.each do |s|
      data = Array.new(22)
      data = Array.new(23) if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
      # IEB AMO 项目添加 自定义字段 English description
      if s[:external_system_id].eql?('000q00040ldeyhJAU9f5km')
        if headers.size > 23
          data = Array.new(24)
        else
          data = Array.new(23)
        end
      end

      data[0] = s[:request_number]
      data[1] = s[:external_system_name]
      data[2] = s[:requested_name]
      data[3] = s[:supporter_name]
      data[4] = s[:priority_name]
      data[5] = s[:incident_category_name]
      data[6] = s[:incident_sub_category_name]
      data[7] = s[:submitted_date].strftime('%F %T')
      data[8] = s[:last_response_date].strftime('%F %T')
      data[9] = s[:title]
      data[10] = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(s[:summary],""))  unless s[:summary].nil?
      data[11] = s[:contact_name]
      data[12] = s[:contact_number]
      data[13] = s[:client_info]
      data[14] = s[:incident_status_name]
      data[15] = s[:total_processing_time]
      data[16] = s[:total_processing_time_remote]
      data[17] = s[:total_processing_time_scene]
      #get first assign
      first_assign_journal = Icm::IncidentJournal.
          where("incident_request_id = ?", s.id).
          where("reply_type = ?", "ASSIGN").
          select("created_at").
          order("created_at ASC").limit(1)
      if first_assign_journal.any?
        data[18] = first_assign_journal.first[:created_at].strftime("%F %T")
      else
        data[18] = ""
      end
      sla = Slm::SlaInstance.where("bo_id = ?", s.id).where("current_duration > max_duration")
      if sla.any?
        data[19] = 'Y'
      else
        data[19] = 'N'
      end
      #Rating
      ratings = Irm::Rating.
          select("rcg.name").
          joins(",#{Irm::RatingConfigGrade.table_name} rcg").
          where("rcg.grade = #{Irm::Rating.table_name}.grade").
          where("#{Irm::Rating.table_name}.rating_object_id = ?", s.id).
          order("#{Irm::Rating.table_name}.created_at DESC")
      if ratings.any?
        data[20] = ratings.first[:name]
      else
        data[20] = ""
      end

      if s.charging_time.present?
        data[21] = s.charging_time.to_s
      else
        data[21] = ""
      end

      if params[:inc_history].present? && params[:inc_history].eql?(Irm::Constant::SYS_YES)
        messages = ''
        messages << s.concat_journals_with_text
        messages = Irm::Sanitize.trans_html(Irm::Sanitize.sanitize(messages,""))
        data[22] = messages
      end

      # 给 IEB AMO 添加自定义字段显示 English description  IEB AMO的id为：000q00040ldeyhJAU9f5km
      if s[:external_system_id].eql?('000q00040ldeyhJAU9f5km')
        if headers.size > 23
          data[23] = s[:sattribute1]
        else
          data[22] = s[:sattribute1]
        end
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