class Icm::ApiIncidentRequestsController < ApiController
  #创建事故单
  #Request /api_incident_requests/add.json
  def add
    incident_hash = {:requested_by => params[:requested_by],
                     :external_system_id => params[:external_system_id],
                     :incident_category_id => params[:incident_category_id],
                     :incident_sub_category_id => params[:incident_sub_category_id],
                     :estimated_date => params[:estimated_date],
                     :title => params[:title],
                     :summary => params[:summary],
                     :contact_id => params[:contact_id],
                     :contact_number => params[:contact_number] || '123456',
                     :urgence_id => params[:urgence_id],
                     :impact_range_id => params[:impact_range_id],
                     :report_source_code => params[:report_source_code],
                     :incident_status_id => params[:incident_status_id],
                     :request_type_code => params[:request_type_code] }

    incident_request = Icm::IncidentRequest.new(incident_hash)

    incident_request = prepared_for_create(incident_request)

    #将自定义的必填字段用默认值进行设置
    #incident_request.merge_required_default_value
    if incident_request.save
      Icm::IncidentHistory.create({:request_id => incident_request.id,
                                   :journal_id => "",
                                   :property_key => "incident_request_id",
                                   :old_value => incident_request.title,
                                   :new_value => ""})
      #如果没有填写support_group, 插入Delay Job任务
      if incident_request.support_group_id.nil? || incident_request.support_group_id.blank?
        Delayed::Job.enqueue(Icm::Jobs::GroupAssignmentJob.new(incident_request.id), [{:bo_code => "ICM_INCIDENT_REQUESTS", :instance_id => incident_request.id}])
      end
      respond_to do |format|
        format.json {
          render json: incident_request.to_json(:only => @return_columns )
        }
      end
    else
      raise incident_request.errors.full_messages.to_s
    end
  end

  private
    def prepared_for_create(incident_request)
      incident_request.submitted_by = Irm::Person.current.id
      incident_request.submitted_date = Time.now
      incident_request.last_request_date = Time.now
      incident_request.last_response_date = Time.now
      incident_request.next_reply_user_license="SUPPORTER"
      if incident_request.incident_status_id.nil?||incident_request.incident_status_id.blank?
        incident_request.incident_status_id = Icm::IncidentStatus.default_id
      end
      if incident_request.request_type_code.nil?||incident_request.request_type_code.blank?
        incident_request.request_type_code = "REQUESTED_TO_CHANGE"
      end

      if incident_request.report_source_code.nil?||incident_request.report_source_code.blank?
        incident_request.report_source_code = "CUSTOMER_SUBMIT"
      end
      if incident_request.requested_by.present?
        incident_request.contact_id = incident_request.requested_by
      end

      if !incident_request.contact_number.present?&&incident_request.contact_id.present?
        incident_request.contact_number = Irm::Person.find(incident_request.contact_id).bussiness_phone
      end
      incident_request
    end

end