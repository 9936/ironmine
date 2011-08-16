class Icm::IncidentRequestsController < ApplicationController
  # GET /incident_requests
  # GET /incident_requests.xml
  def index
    session[:_view_filter_id] = params[:filter_id] if params[:filter_id]
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /incident_requests/1
  # GET /incident_requests/1.xml
  def show
    @incident_request = Icm::IncidentRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incident_request }
    end
  end

  # GET /incident_requests/new
  # GET /incident_requests/new.xml
  def new
    @incident_request = Icm::IncidentRequest.new

    respond_to do |format|
      format.html { render :layout => "application_full"}# new.html.erb
      format.xml  { render :xml => @incident_request }
    end
  end

  # GET /incident_requests/1/edit
  def edit
    @incident_request = Icm::IncidentRequest.find(params[:id])
    respond_to do |format|
      format.html { render :layout => "application_full"}# new.html.erb
      format.xml  { render :xml => @incident_request }
    end
  end

  # POST /incident_requests
  # POST /incident_requests.xml
  def create
    @incident_request = Icm::IncidentRequest.new(params[:icm_incident_request])
    #加入创建事故单的默认参数
    prepared_for_create(@incident_request)
    respond_to do |format|
      if @incident_request.save
        process_files(@incident_request)
        #publish_create_incident_request(@incident_request)

        #add watchers
        if params[:cwatcher] && params[:cwatcher].size > 0
          params[:cwatcher].collect{|p| [p[0]]}.uniq.each do |w|
            watcher = Irm::Person.find(w)
            @incident_request.person_watchers << watcher
          end
        end

        #如果没有填写support_group, 插入Delay Job任务
        if @incident_request.support_group_id.nil? || @incident_request.support_group_id.blank?
          Delayed::Job.enqueue(Irm::Jobs::IcmGroupAssignmentJob.new(@incident_request.id),
                               [{:bo_code => "ICM_INCIDENT_REQUESTS", :instance_id => @incident_request.id}])
        end
        format.html { redirect_to({:controller=>"icm/incident_journals",:action=>"new",:request_id=>@incident_request.id,:show_info=>Irm::Constant::SYS_YES}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @incident_request, :status => :created, :location => @incident_request }
      else
        format.html { render :action => "new", :layout => "application_full" }
        format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def short_create
    @incident_request = Icm::IncidentRequest.new(params[:icm_incident_request])
    @incident_request.urgence_code = "GLOBAL_NORMAL"
    @incident_request.incident_status_code = "NEW_INCIDENT"
    @incident_request.request_type_code = "REQUESTED_TO_PERFORM"
    @incident_request.service_code = "ORAL_EBS_INV"
    @incident_request.report_source_code = "CUSTOMER_SUBMIT"
    @incident_request.impact_range_code = "GLOBAL_LOW"
    #加入创建事故单的默认参数
    prepared_for_create(@incident_request)
    respond_to do |format|
      if @incident_request.save
        #如果没有填写support_group, 插入Delay Job任务
        if @incident_request.support_group_id.nil? || @incident_request.support_group_id.blank?
          Delayed::Job.enqueue(Irm::Jobs::IcmGroupAssignmentJob.new(@incident_request.id),
                               [{:bo_code => "ICM_INCIDENT_REQUESTS", :instance_id => @incident_request.id}])
        end
        format.html { redirect_to({:controller=>"icm/incident_journals",:action=>"new",:request_id=>@incident_request.id,:show_info=>Irm::Constant::SYS_YES}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @incident_request, :status => :created, :location => @incident_request }
      else
        format.html { render :action => "new", :layout => "application_full" }
        format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
      end
    end      
  end
  
  # PUT /incident_requests/1
  # PUT /incident_requests/1.xml
  def update
    @incident_request = Icm::IncidentRequest.find(params[:id])

    respond_to do |format|
      if @incident_request.update_attributes(params[:icm_incident_request])
        format.html { redirect_to({:action=>"index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :layout => "application_full" }
        format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    return_columns = [:request_number,
                      :company_name,
                      :title,
                      :incident_status_name,
                      :close_flag,
                      :requested_name,
                      :need_customer_reply,
                      :last_response_date]
    bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first
    incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).query_by_company_ids(session[:accessable_companies]).order("close_flag ,last_response_date desc,last_request_date desc,weight_value,company_id")

    if !allow_to_function?(:view_all_incident_request)
      incident_requests_scope = incident_requests_scope.relate_person(Irm::Person.current.id)
    end

    incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.request_number",params[:request_number])
    incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.title",params[:title])


    respond_to do |format|
      format.json {
        incident_requests,count = paginate(incident_requests_scope)
        render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count,{:date_to_distance=>[:last_response_date]}))
      }
      format.xml {
        incident_requests,count = paginate(incident_requests_scope)
        render :xml => incident_requests
      }
      format.xls{
        incident_requests = data_filter(incident_requests_scope)
        send_data(incident_requests.to_xls(:only => [:request_number,:title,:company_name,:incident_status_name,:last_response_date],
                                       :headers=>["#",   t(:label_icm_incident_request_title),
                                                         t(:label_icm_incident_request_company),
                                                         t(:label_icm_incident_request_incident_status_code),
                                                         t(:label_icm_incident_request_last_date)]
                                             ))}
    end
  end

  def get_help_desk_data
    return_columns = [:request_number,
                      :company_name,
                      :title,
                      :incident_status_name,
                      :close_flag,
                      :requested_name,
                      :need_customer_reply,
                      :last_request_date,
                      :priority_name]
    bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first
    incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).query_by_company_ids(session[:accessable_companies]).order("close_flag ,last_request_date desc,last_response_date desc,weight_value,company_id,id")
    if !allow_to_function?(:view_all_incident_request)
      incident_requests_scope = incident_requests_scope.relate_person(Irm::Person.current.id)
    end
    incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.request_number",params[:request_number])
    incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.title",params[:title])

    respond_to do |format|
      format.json {
        incident_requests,count = paginate(incident_requests_scope)
        render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count,{:date_to_distance=>[:last_request_date]}))
      }
      format.xml {
        incident_requests,count = paginate(incident_requests_scope)
        render :xml => incident_requests
      }
      format.xls{
        incident_requests = data_filter(incident_requests_scope)
        send_data(incident_requests.to_xls(:only => [:request_number,:title,:company_name,:incident_status_name,:priority_name,:last_request_date],
                                       :headers=>["#",   t(:label_icm_incident_request_title),
                                                         t(:label_icm_incident_request_company),
                                                         t(:label_icm_incident_request_incident_status_code),
                                                         t(:label_icm_incident_request_priority),
                                                         t(:label_icm_incident_request_last_date)]
                                             ))}
    end
  end

  def save_as_skm

  end

  def get_external_systems
    external_systems_scope = Uid::ExternalSystem.multilingual.enabled.with_person(params[:requested_by])
    external_systems_scope = external_systems_scope.uniq
    external_systems = external_systems_scope.collect{|i| {:label=>i[:system_name], :value=>i.external_system_code,:id=>i.id}}
    respond_to do |format|
      format.json {render :json=>external_systems.to_grid_json([:label, :value],external_systems.count)}
    end
  end

  def get_slm_services
    requested_by = Irm::Person.current
    if params[:requested_by] && !params[:requested_by].blank?
      requested_by = Irm::Person.find(params[:requested_by])
    end

    #按人员查找
    r1 = Slm::ServiceMember.where("1=1").query_by_service_person(requested_by).with_service_catalog
    #按部门查找
    r1 += Slm::ServiceMember.where(:service_person_id=>nil).query_by_service_department(requested_by.department_id).with_service_catalog
    #按组织查找
    r1 += Slm::ServiceMember.where(:service_person_id=>nil).
                              where(:service_department_id=>nil).
                              query_by_service_organization(requested_by.organization_id).with_service_catalog
    #按公司查找
    r1 += Slm::ServiceMember.where(:service_person_id=>nil).
                              where(:service_department_id=>nil).
                              where(:service_organization_id=>nil).
                              query_by_service_company(requested_by.company_id).with_service_catalog

    services_scope = Slm::ServiceCatalog.multilingual.enabled.where("external_system_code = ? AND catalog_code IN (?)",
                                                                    params[:external_system_code], r1.collect(&:catalog_code))
    services = services_scope.collect{|i| {:label => i[:name], :value => i.catalog_code, :id => i.id}}
    respond_to do |format|
      format.json {render :json=>services.to_grid_json([:label, :value],services.count)}
    end
  end

  def get_all_slm_services
    services_scope = Slm::ServiceCatalog.multilingual.enabled.where("external_system_code = ?",params[:external_system_code])

    services = services_scope.collect{|i| {:label => i[:name], :value => i.catalog_code, :id => i.id}}
    respond_to do |format|
      format.json {render :json=>services.to_grid_json([:label, :value],services.count)}
    end
  end

  def assign_dashboard
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def assignable_data
    return_columns = [:request_number,
                      :company_name,
                      :title,
                      :incident_status_name,
                      :close_flag,
                      :requested_name,
                      :last_request_date,
                      :priority_name]
    bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first
    incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).query_by_company_ids(session[:accessable_companies]).order("created_at")
    incident_requests_scope = incident_requests_scope.where("support_person_id IS NULL")

    respond_to do |format|
      format.json {
        incident_requests,count = paginate(incident_requests_scope)
        render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count))
      }
      format.xml {
        incident_requests,count = paginate(incident_requests_scope)
        render :xml => incident_requests
      }
    end
  end

  def assign_request

    incident_requests = []
    params[:incident_request_ids].split(",").each do |icid|
      incident_requests << Icm::IncidentRequest.query(icid).first
    end
    incident_requests.compact!
    incident_requests.each do |req|
      if params[:support_group_id].present?
        if params[:support_person_id]
          Delayed::Job.enqueue(Irm::Jobs::IcmGroupAssignmentJob.new(req.id,{:support_group_id=>params[:support_group_id],:support_person_id=>params[:support_person_id],:assign_dashboard=>true,:assign_dashboard_operator=>Irm::Person.current.id}))
        else
          Delayed::Job.enqueue(Irm::Jobs::IcmGroupAssignmentJob.new(req.id,{:support_group_id=>params[:support_group_id],:assign_dashboard=>true,:assign_dashboard_operator=>Irm::Person.current.id}))
        end
      else
        Delayed::Job.enqueue(Irm::Jobs::IcmGroupAssignmentJob.new(req.id,{}))
      end
    end
    @count = incident_requests.size
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def prepared_for_create(incident_request)
    incident_request.submitted_by = Irm::Person.current.id
    incident_request.submitted_date = Time.now
    incident_request.last_request_date = Time.now
    incident_request.last_response_date = 1.minute.ago
    incident_request.next_reply_user_license="SUPPORTER"
    incident_request.company_id = Irm::Person.find(incident_request.requested_by).company_id
    if incident_request.incident_status_id.nil?||incident_request.incident_status_id.blank?
      incident_request.incident_status_id = Icm::IncidentStatus.default_id
    end
    if incident_request.request_type_code.nil?||incident_request.request_type_code.blank?
      incident_request.request_type_code = "REQUESTED_TO_CHANGE"
    end

    if incident_request.report_source_code.nil?||incident_request.report_source_code.blank?
      incident_request.report_source_code = "CUSTOMER_SUBMIT"
    end
    if incident_request.contact_id.nil?||incident_request.contact_id.blank?
      incident_request.contact_id = incident_request.requested_by
      incident_request.contact_number = Irm::Person.find(incident_request.requested_by).mobile_phone
    end
  end


  def process_files(ref_request)
    @files = []
    params[:files].each do |key,value|
      @files << Irm::AttachmentVersion.create({:source_id=>ref_request.id,
                                               :source_type=>ref_request.class.name,
                                               :data=>value[:file],
                                               :description=>value[:description]}) if(value[:file]&&!value[:file].blank?)
    end if params[:files]

    @files.each do|f|
      puts f.errors
    end
  end

  def publish_create_incident_request(incident_request)
    incident_request.reload
    incident_request = Icm::IncidentRequest.list_all.find(incident_request.id)
    request_url = url_for({:host=>Irm::Constant::DEFAULT_HOST,
             :controller=>"icm/incident_journals",
             :action =>"new",
             :request_id=>incident_request.id})
    Irm::EventManager.publish(:event_code=>"INCIDENT_REQUEST_NEW",
                              :params=>{:to_person_ids=>[incident_request.submitted_by,incident_request.requested_by],
                                        :request=>incident_request.attributes.merge({:url=>request_url})})
  end
end
