class IncidentAge < Irm::ReportManager::ReportBase
  def data(params={})
    params||={}
    language = I18n.locale
    incident_requests = Icm::IncidentRequest.
                        joins("JOIN #{Icm::IncidentStatus.view_name} incident_status ON  incident_status.id = #{Icm::IncidentRequest.table_name}.incident_status_id AND incident_status.language= '#{language}'").
                        where("incident_status.close_flag = ?",Irm::Constant::SYS_NO)


    show_option = params[:show_option]||"SUPPORT_GROUP"

    time_unit = params[:time_unit]||"HOUR"

    time_lead = (params[:time_lead]||"none").gsub(/\D/,"")

    compare_date = nil

    show_detail = params[:show_detail].present?

    if time_unit.present?&&time_lead.present?
      if(time_unit.eql?("HOUR"))
        compare_date = time_lead.to_i.hours.ago
      else
        compare_date = time_lead.to_i.days.ago
      end
    end

    # 处理事故单参数
    if(params[:date_from].present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.submitted_date >= ?",params[:date_from])
    end

    if(params[:date_to].present?&&!compare_date.present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.submitted_date <= ?",params[:date_to])
    end

    if compare_date.present?
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.submitted_date <= ?",compare_date)
    end

    if(params[:organization_id].present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.organization_id = ?",params[:organization_id])
    end

    if(params[:support_group_id].present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.support_group_id = ?",params[:support_group_id])
    end

    if(params[:incident_status_id].present?)
      incident_requests = incident_requests.where("#{Icm::IncidentRequest.table_name}.incident_status_id = ?",params[:incident_status_id])
    end

    headers = []
    datas = []
    if !show_detail
      headers =[I18n.t(:label_icm_incident_request_organization), I18n.t(:label_icm_incident_request_support_group),I18n.t(:label_icm_incident_request_incident_status), I18n.t(:label_summary)]
      incident_requests = incident_requests.
                            group("#{Icm::IncidentRequest.table_name}.organization_id,#{Icm::IncidentRequest.table_name}.support_group_id,#{Icm::IncidentRequest.table_name}.incident_status_id").
                            select("#{Icm::IncidentRequest.table_name}.organization_id,#{Icm::IncidentRequest.table_name}.support_group_id,#{Icm::IncidentRequest.table_name}.incident_status_id,count(*) amount")

      incident_requests.each do |incident_request|
        data = []
        organization = Irm::Organization.multilingual.query(incident_request[:organization_id]).first
        if organization
          data << organization[:name]
        else
          data << ""
        end

        support_group = Icm::SupportGroup.with_group(language).query(incident_request[:support_group_id]).first
        if support_group
          data << support_group[:name]
        else
          data << ""
        end

        incident_status = Icm::IncidentStatus.multilingual.query(incident_request[:incident_status_id]).first
        if incident_status
          data << incident_status[:name]
        else
          data << ""
        end
        data << incident_request[:amount]
        datas << data
      end
    else
      headers = [I18n.t(:label_icm_incident_request_request_number),I18n.t(:label_icm_incident_request_title),I18n.t(:label_icm_incident_request_organization),I18n.t(:label_icm_incident_request_submitted_by),I18n.t(:label_icm_incident_request_submitted_date),I18n.t(:label_icm_incident_request_support_group),I18n.t(:label_icm_incident_request_support_person)]
      incident_requests = incident_requests.joins("LEFT OUTER JOIN #{Icm::SupportGroup.multilingual_view_name} ON  #{Icm::IncidentRequest.table_name}.support_group_id = #{Icm::SupportGroup.multilingual_view_name}.id AND #{Icm::SupportGroup.multilingual_view_name}.language = '#{language}'").
                            joins("JOIN #{Irm::Organization.view_name}  ON  #{Irm::Organization.view_name}.id = #{Icm::IncidentRequest.table_name}.organization_id AND  #{Irm::Organization.view_name}.language = '#{language}'").
                            joins("LEFT OUTER JOIN #{Irm::Person.table_name} supporter ON  supporter.id = #{Icm::IncidentRequest.table_name}.support_person_id").
                            joins("JOIN #{Irm::Person.table_name} submitted ON  submitted.id = #{Icm::IncidentRequest.table_name}.submitted_by").
          select("#{Icm::IncidentRequest.table_name}.request_number,#{Icm::IncidentRequest.table_name}.title,#{Icm::IncidentRequest.table_name}.submitted_date,#{Icm::SupportGroup.multilingual_view_name}.name support_group_name, #{Irm::Organization.view_name}.name organization_name,supporter.full_name supporter,submitted.full_name submitter").
          order("#{Icm::IncidentRequest.table_name}.submitted_date desc")

      incident_requests.each do |incident_request|
        datas<<[incident_request[:request_number],incident_request[:title],incident_request[:organization_name],incident_request[:submitter],incident_request[:submitted_date].strftime('%Y-%m-%d %H:%M:%S'),incident_request[:support_group_name],incident_request[:supporter]]
      end
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
      excel_data << {:request_number=>data[:request_number],
                     :title=>data[:title],
                     :requested_organization_name=>data[:requested_organization_name],
                     :requested_name=>data[:requested_name],
                     :external_system_name=>data[:external_system_name],
                     :service_name=>data[:service_name],
                     :priority_name=>data[:priority_name]}.merge(result[:report_datas][index].to_cus_hash)
    end

    excel_data.to_xls(columns,{})
  end
end