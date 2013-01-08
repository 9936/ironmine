module Htc::IncidentRequestsControllerEx
  def self.included(base)
    base.class_eval do
      def get_data
        return_columns = [:request_number,
                          :organization_id,
                          :organization_id_label,
                          :title,
                          :incident_status_id,
                          :incident_status_id_label,
                          :close_flag,
                          :requested_by,
                          :requested_by_label,
                          :support_group_id,
                          :support_group_id_label,
                          :support_person_id,
                          :support_person_id_label,
                          :last_response_date,
                          :external_system_id,
                          :external_system_id_label,
                          :incident_category_id,
                          :incident_category_id_label,
                          :incident_sub_category_id,
                          :incident_sub_category_id_label,
                          :estimated_date,
                          :cux_organization_id,
                          :cux_organization_id_label,
                          :kb_flag,
                          :reply_flag]
        bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first

        incident_status_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_status_id")
        supporter_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"support_person_id")
        incident_category_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_category_id")
        incident_sub_category_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_sub_category_id")
        #role_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"cux_organization_id")
        incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).with_reply_flag(Irm::Person.current.id).
            filter_system_ids(Irm::Person.current.system_ids).relate_person(Irm::Person.current.id)
            #order("close_flag ,reply_flag desc,last_response_date desc,last_request_date desc,weight_value")

        incident_requests_scope = incident_requests_scope.select("#{incident_status_table_alias}.close_flag,#{incident_status_table_alias}.display_color")  if incident_status_table_alias.present?

        incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.request_number",params[:request_number])
        incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.title",params[:title])
        incident_requests_scope = incident_requests_scope.match_value("#{Irm::ExternalSystem.view_name}.system_name",params[:external_system_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{supporter_table_alias}.full_name",params[:support_person_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{incident_category_table_alias}.name",params[:incident_category_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{incident_sub_category_table_alias}.name",params[:incident_sub_category_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{incident_status_table_alias}.name",params[:incident_status_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.attribute2",params[:attribute2])

        if params[:order_name]
          order_value = params[:order_value] ? params[:order_value] : "DESC"
          incident_requests_scope = incident_requests_scope.order("#{params[:order_name]} #{order_value}")
        else
          incident_requests_scope = incident_requests_scope.order("last_response_date DESC")
        end

        respond_to do |format|
          format.json {
            incident_requests,count = paginate(incident_requests_scope)
            render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count))
          }
          format.html {
            @datas,@count = paginate(incident_requests_scope)
          }
          format.xls{
            incident_requests = data_filter(incident_requests_scope)
            send_data(data_to_xls(incident_requests,
                                  [{ :key => "request_number", :label => t(:label_icm_incident_request_request_number_shot)},
                                   { :key => "title",:label => t(:label_icm_incident_request_title)},
                                   { :key => "external_system_id_label", :label => t(:label_irm_external_system)},
                                   { :key => "priority_id_label", :label => t(:label_icm_incident_request_priority)},
                                   { :key => "incident_category_id_label", :label => t(:label_icm_incident_category)},
                                   { :key => "incident_sub_category_id_label", :label => t(:label_icm_incident_sub_category)},
                                   { :key => "submitted_date", :label => t(:label_icm_incident_request_submitted_date)},
                                   { :key => "last_response_date", :label => t(:label_icm_incident_request_last_date)},
                                   { :key => "incident_status_id_label", :label => t(:label_icm_incident_request_incident_status)},
                                   { :key => "support_person_id_label", :label => t(:label_icm_incident_request_support_person)}]
                      ))
          }
        end
      end

      def get_help_desk_data
        return_columns = [:request_number,
                          :organization_id,
                          :organization_id_label,
                          :title,
                          :incident_status_id,
                          :incident_status_id_label,
                          :close_flag,
                          :requested_by,
                          :support_person_id,
                          :requested_by_label,
                          :last_request_date,
                          :priority_id_label,
                          :external_system_id_label,
                          :external_system_id,
                          :incident_category_id,
                          :incident_category_id_label,
                          :incident_sub_category_id,
                          :incident_sub_category_id_label,
                          :kb_flag,
                          :estimated_date,
                          :cux_organization_id,
                          :cux_organization_id_label,
                          :reply_flag]
        bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first
        incident_status_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_status_id")
        supporter_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"support_person_id")
        incident_category_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_category_id")
        incident_sub_category_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_sub_category_id")
        #role_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"cux_organization_id")

        incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).with_reply_flag(Irm::Person.current.id).
            filter_system_ids(Irm::Person.current.system_ids).relate_person(Irm::Person.current.id)
            #order("close_flag ,reply_flag desc,last_request_date desc,last_response_date desc,weight_value,id")


        incident_requests_scope = incident_requests_scope.select("#{incident_status_table_alias}.close_flag,#{incident_status_table_alias}.display_color")  if incident_status_table_alias.present?


        incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.request_number",params[:request_number])
        incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.title",params[:title])
        incident_requests_scope = incident_requests_scope.match_value("#{Irm::ExternalSystem.view_name}.system_name",params[:external_system_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{supporter_table_alias}.full_name",params[:support_person_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{incident_category_table_alias}.name",params[:incident_category_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{incident_sub_category_table_alias}.name",params[:incident_sub_category_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{incident_status_table_alias}.name",params[:incident_status_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{Icm::PriorityCode.view_name}.name",params[:priority_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.attribute2",params[:attribute2])

        if params[:order_name]
          order_value = params[:order_value] ? params[:order_value] : "DESC"
          incident_requests_scope = incident_requests_scope.order("#{params[:order_name]} #{order_value}")
        else
          incident_requests_scope = incident_requests_scope.order("last_response_date DESC")
        end

        respond_to do |format|
          format.json {
            incident_requests,count = paginate(incident_requests_scope)
            render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count))
          }
          format.html {
            @datas,@count = paginate(incident_requests_scope)
          }
          format.xls{
            incident_requests = data_filter(incident_requests_scope)
            send_data(data_to_xls(incident_requests,
                                          [{ :key => "request_number", :label => t(:label_icm_incident_request_request_number_shot)},
                                             { :key => "title",:label => t(:label_icm_incident_request_title)},
                                             { :key => "external_system_id_label", :label => t(:label_irm_external_system)},
                                             { :key => "priority_id_label", :label => t(:label_icm_incident_request_priority)},
                                             { :key => "incident_category_id_label", :label => t(:label_icm_incident_category)},
                                             { :key => "incident_sub_category_id_label", :label => t(:label_icm_incident_sub_category)},
                                             { :key => "submitted_date", :label => t(:label_icm_incident_request_submitted_date)},
                                             { :key => "last_response_date", :label => t(:label_icm_incident_request_last_date)},
                                             { :key => "incident_status_id_label", :label => t(:label_icm_incident_request_incident_status)},
                                             { :key => "support_person_id_label", :label => t(:label_icm_incident_request_support_person)}]
                      ))
          }

        end
      end
    end
  end
end