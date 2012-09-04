class Icm::IncidentRequestsController < ApplicationController
  layout 'bootstrap_application'
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
    @incident_request = Icm::IncidentRequest.new(({:requested_by=>Irm::Person.current.id}).merge(params[:icm_incident_request]||{}))
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html { render :layout => "bootstrap_application_full"}# new.html.erb
      format.xml  { render :xml => @incident_request }
    end
  end

  # GET /incident_rsolr_searchequests/1/edit
  def edit
    @incident_request = Icm::IncidentRequest.find(params[:id])
    respond_to do |format|
      format.html { render :layout => "bootstrap_application_full"}# new.html.erb
      format.xml  { render :xml => @incident_request }
    end
  end

  # POST /incident_requests
  # POST /incident_requests.xml
  def create
    @incident_request = Icm::IncidentRequest.new(params[:icm_incident_request])
    @return_url = params[:return_url] if params[:return_url]
    #加入创建事故单的默认参数
    prepared_for_create(@incident_request)
    respond_to do |format|
      flag = true
      flag, now = validate_files(@incident_request) if params[:files].present?
      if !flag
        if now.is_a?(Integer)
          flash[:error] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
        else
          flash[:error] = now
        end

        format.html { render :action => "new", :layout=>"bootstrap_application_full"}
        format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
        format.json { render :json => @incident_request.errors, :status => :unprocessable_entity }
      elsif @incident_request.save
        process_files(@incident_request)
        #add watchers
        #if params[:cwatcher] && params[:cwatcher].size > 0
        #  params[:cwatcher].collect{|p| [p[0]]}.uniq.each do |w|
        #    watcher = Irm::Person.find(w)
        #    @incident_request.person_watchers << watcher
        #  end
        #end

        Icm::IncidentHistory.create({:request_id => @incident_request.id,
                                     :journal_id=> "",
                                     :property_key=> "incident_request_id",
                                     :old_value=> @incident_request.title,
                                     :new_value=> ""})

        #如果没有填写support_group, 插入Delay Job任务
        if @incident_request.support_group_id.nil? || @incident_request.support_group_id.blank?
          Delayed::Job.enqueue(Icm::Jobs::GroupAssignmentJob.new(@incident_request.id), [{:bo_code => "ICM_INCIDENT_REQUESTS", :instance_id => @incident_request.id}])
        end
        format.html { redirect_to({:controller=>"icm/incident_journals",:action=>"new",:request_id=>@incident_request.id,:show_info=>Irm::Constant::SYS_YES}) }
        format.xml  { render :xml => @incident_request, :status => :created, :location => @incident_request }
        format.json { render :json => @incident_request}
      else
        format.html { render :action => "new", :layout => "bootstrap_application_full" }
        format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
        format.json { render :json => @incident_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def short_create
    @incident_request = Icm::IncidentRequest.new(params[:icm_incident_request])
    @incident_request.urgence_id = Icm::UrgenceCode.default_id
    @incident_request.incident_status_id = Icm::IncidentStatus.default_id
    @incident_request.request_type_code = "REQUESTED_TO_PERFORM"
    @incident_request.report_source_code = "CUSTOMER_SUBMIT"
    @incident_request.impact_range_id = Icm::ImpactRange.default_id
    #加入创建事故单的默认参数
    prepared_for_create(@incident_request)
    respond_to do |format|
      if @incident_request.valid?

        if @incident_request.save
          #如果没有填写support_group, 插入Delay Job任务
          if @incident_request.support_group_id.nil? || @incident_request.support_group_id.blank?
            Delayed::Job.enqueue(Icm::Jobs::GroupAssignmentJob.new(@incident_request.id),
                                 [{:bo_code => "ICM_INCIDENT_REQUESTS", :instance_id => @incident_request.id}])
          end
          format.html { redirect_to({:controller=>"icm/incident_journals",:action=>"new",:request_id=>@incident_request.id,:show_info=>Irm::Constant::SYS_YES}) }
          format.xml  { render :xml => @incident_request, :status => :created, :location => @incident_request }
        else
          format.html { render :action => "new", :layout => "bootstrap_application_full"}
          format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
        end
      else
        #@incident_request.errors[:requested_by] << I18n.t(:error_icm_requested_by_can_not_blank)
        format.html { render :action => "new", :layout => "bootstrap_application_full" }
        format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
      end
    end      
  end

  def update
    @incident_reply = Icm::IncidentReply.new(params[:icm_incident_reply])
    @incident_request = Icm::IncidentRequest.find(params[:id])
    respond_to do |format|
      flag, now = validate_files(@incident_request)
      if !flag
        flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
        format.html { render :action => "edit", :layout=>"bootstrap_application_full"}
        format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
      elsif @incident_request.update_attributes(params[:icm_incident_request])
        process_files(@incident_request)
        process_change_attributes(Icm::IncidentReply.all_attributes,@incident_request,@incident_request_bak, @incident_request.id)
        format.html { redirect_to({:controller=>"icm/incident_journals",:action=>"new",:request_id=>@incident_request.id,:show_info=>Irm::Constant::SYS_YES}) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :layout => "bootstrap_application_full" }
        format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
      end
    end
  end

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
                      :estimated_date,
                      :kb_flag,
                      :reply_flag]
    bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first

    incident_status_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_status_id")

    incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).with_reply_flag(Irm::Person.current.id).
        filter_system_ids(Irm::Person.current.system_ids).relate_person(Irm::Person.current.id).
        order("last_response_date desc")
        #order("close_flag ,reply_flag desc,last_response_date desc,last_request_date desc,weight_value")

    #if !allow_to_function?(:view_all_incident_request)
    #  incident_requests_scope = incident_requests_scope
    #end

    incident_requests_scope = incident_requests_scope.select("#{incident_status_table_alias}.close_flag,#{incident_status_table_alias}.display_color")  if incident_status_table_alias.present?

    incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.request_number",params[:request_number])
    incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.title",params[:title])


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
                              [{:key=>:request_number,:label=>t(:label_icm_incident_request_request_number_shot)},
                               {:key=>:title,:label=>t(:label_icm_incident_request_title)},
                               {:key=>:incident_status_id_label,:label=>t(:label_icm_incident_request_incident_status_code)},
                               {:key=>:last_response_date,:label=>t(:label_icm_incident_request_last_date)},
                               {:key=>:external_system_id_label,:label=>t(:label_irm_external_system)}]
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
                      :kb_flag,
                      :estimated_date,
                      :reply_flag]
    bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first
    incident_status_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_status_id")

    incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).with_reply_flag(Irm::Person.current.id).
        filter_system_ids(Irm::Person.current.system_ids).relate_person(Irm::Person.current.id).
        order("last_request_date desc")
        #order("close_flag ,reply_flag desc,last_request_date desc,last_response_date desc,weight_value,id")


    incident_requests_scope = incident_requests_scope.select("#{incident_status_table_alias}.close_flag,#{incident_status_table_alias}.display_color")  if incident_status_table_alias.present?


    incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.request_number",params[:request_number])
    incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.title",params[:title])

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
                              [{:key=>:request_number,:label=>t(:label_icm_incident_request_request_number_shot)},
                               {:key=>:title,:label=>t(:label_icm_incident_request_title)},
                               {:key=>:incident_status_id_label,:label=>t(:label_icm_incident_request_incident_status_code)},
                               {:key=>:organization_id_label,:label=>t(:label_icm_incident_request_organization)},
                               {:key=>:priority_id_label,:label=>t(:label_icm_incident_request_priority)},
                               {:key=>:last_request_date,:label=>t(:label_icm_incident_request_last_date)},
                               {:key=>:external_system_id_label,:label=>t(:label_irm_external_system)}]
                  ))
      }

    end
  end

  def save_as_skm

  end

  def get_external_systems
    external_systems_scope = Irm::ExternalSystem.multilingual.enabled.with_person(params[:requested_by]).order("CONVERT( system_name USING gbk ) ")
    external_systems_scope = external_systems_scope.uniq
    external_systems = external_systems_scope.collect{|i| {:label=>i[:system_name], :value=>i.id,:id=>i.id}}
    respond_to do |format|
      format.json {render :json=>external_systems.to_grid_json([:label, :value],external_systems.count)}
    end
  end

  def get_slm_services


    services_scope = Slm::ServiceCatalog.multilingual.enabled.query_by_external_system(params[:external_system_id])
    services = services_scope.collect{|i| {:label => i[:name], :value => i.catalog_code, :id => i.id}}
    respond_to do |format|
      format.json {render :json=>services.to_grid_json([:label, :value],services.count)}
    end
  end

  def get_all_slm_services
    services_scope = Slm::ServiceCatalog.multilingual.enabled.where("external_system_id = ?",params[:external_system_id])

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
                      :title,
                      :organization_id,:organization_id_label,
                      :incident_status_id,:incident_status_id_label,
                      :close_flag,
                      :requested_by,:requested_by_label,
                      :last_request_date,
                      :priority_id,:priority_id_label,
                      :external_system_id,:external_system_id_label]
    bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first
    incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).
        with_external_system(I18n.locale).
        where("LENGTH(external_system_id) > 0").
        where("external_system_id IN (?)", Irm::Person.current.system_ids).
        order("created_at")
    incident_requests_scope = incident_requests_scope.where("support_person_id IS NULL")
    incident_requests,count = paginate(incident_requests_scope)
    respond_to do |format|
      format.json {

        render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count))
      }
      format.html {
        @datas = incident_requests
        @count = count
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
          Delayed::Job.enqueue(Icm::Jobs::GroupAssignmentJob.new(req.id,{:support_group_id=>params[:support_group_id],:support_person_id=>params[:support_person_id],:assign_dashboard=>true,:assign_dashboard_operator=>Irm::Person.current.id}))
        else
          Delayed::Job.enqueue(Icm::Jobs::GroupAssignmentJob.new(req.id,{:support_group_id=>params[:support_group_id],:assign_dashboard=>true,:assign_dashboard_operator=>Irm::Person.current.id}))
        end
      else
        Delayed::Job.enqueue(Icm::Jobs::GroupAssignmentJob.new(req.id,{}))
      end
    end
    @count = incident_requests.size
    respond_to do |format|
      format.html {
        redirect_back_or_default
      }
      format.js
    end
  end


  # 领取事故单
  def edit_assign_me
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def update_assign_me

    incident_requests = []
    params[:incident_request_ids].split(",").each do |icid|
      incident_requests << Icm::IncidentRequest.find(icid)
    end

    incident_requests.each do |irq|
      request_attributes = {}
      journal_attributes = {}
      journal_attributes.merge!(:message_body=>I18n.t(:label_icm_incident_request_assign_me))
      journal_attributes.merge!(:reply_type => "ASSIGN")
      journal_attributes.merge!(:replied_by => Irm::Person.current.id)
      request_attributes.merge!({:incident_status_id=>Icm::IncidentStatus.transform(irq.incident_status_id,"ASSIGN")})
      request_attributes.merge!({:support_person_id=>Irm::Person.current.id,:charge_person_id=>Irm::Person.current.id,:upgrade_person_id=>Irm::Person.current.id})

      incident_journal = Icm::IncidentJournal::generate_journal(irq,request_attributes,journal_attributes)
    end


    respond_to do |format|
        format.html { redirect_back_or_default({:action => "edit_assign_me"}) }
        format.xml  { render :xml => incident_requests, :status => :updated, :location => incident_requests }
    end
  end

  def assign_me_data
    return_columns = [:request_number,
                      :title,
                      :organization_id,:organization_id_label,
                      :incident_status_id,:incident_status_id_label,
                      :close_flag,
                      :requested_by,:requested_by_label,
                      :last_request_date,
                      :priority_id,:priority_id_label,
                      :external_system_id,:external_system_id_label]
    bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first
    incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).
        with_external_system(I18n.locale).
        where("LENGTH(external_system_id) > 0").
        where("external_system_id IN (?)", Irm::Person.current.system_ids).
        assignable_to_person(Irm::Person.current.id).
        order("created_at")
    incident_requests,count = paginate(incident_requests_scope)
    respond_to do |format|
      format.json {
        render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count))
      }
      format.html {
        @datas = incident_requests
        @count = count
      }
      format.xml {
        incident_requests,count = paginate(incident_requests_scope)
        render :xml => incident_requests
      }
    end

  end

  def kanban_index

  end

  def remove_exists_attachments
#    @file = Irm::Attachment.where(:latest_version_id => params[:att_id]).first
    @attachments = Irm::AttachmentVersion.query_all.
        where(:source_id => params[:incident_request_id]).
        where(:source_type => Icm::IncidentRequest.name).
        where(:id => params[:att_id]).first
    @incident_request = Icm::IncidentRequest.find(params[:incident_request_id])
    respond_to do |format|
      if @attachments.destroy
          format.js { render :remove_exits_attachments}
      end
    end
  end

  def add_relation
    #确保事故单不能关联自身

    unless params[:source_id].eql?(params[:icm_relation])
      @incident_request = Icm::IncidentRequest.find(params[:source_id])
      existed_relation = Icm::IncidentRequestRelation.where("(source_id = ? AND target_id = ?) OR (source_id = ? AND target_id = ?)", params[:source_id], params[:icm_relation], params[:icm_relation], params[:source_id])
      unless existed_relation.any? || !params[:icm_relation].present?
        t = Icm::IncidentRequestRelation.create(:source_id => params[:source_id], :target_id => params[:icm_relation], :relation_type => params[:relation_type])
        Icm::IncidentHistory.create({:request_id => params[:source_id],
                                     :journal_id=> "",
                                     :property_key=> "add_relation",
                                     :old_value=>params[:relation_type],
                                     :new_value=>params[:icm_relation]})
      end
    end
    @dom_id = params[:_dom_id]
    respond_to do |format|
      format.js {render :add_relation}
    end
  end

  def remove_relation
    relation = Icm::IncidentRequestRelation.find(params[:id])
    Icm::IncidentHistory.create({:request_id => params[:source_id],
                                 :journal_id=> "",
                                 :property_key=> "remove_relation",
                                 :old_value=>relation.relation_type,
                                 :new_value=>relation.source_id})
    relation.destroy
    @incident_request =  Icm::IncidentRequest.find(relation.source_id)
    @dom_id = params[:_dom_id]
    respond_to do |format|
      format.js {render :add_relation}
    end
  end

  def info_card
    @incident_request_info = Icm::IncidentRequest.list_all.find(params[:request_id])
    render :layout => "common_all"
  end

  def remove_attachment
    attachment = Irm::AttachmentVersion.find(params[:attachment_id])
    source_id = attachment.source_id
    source = eval(attachment.source_type).find(source_id)
    name = attachment.name

    if source.source_type.eql?("Icm::IncidentRequest")
      request_id = source.id
      journal_id = ""
    else source.source_type.eql?("Icm::IncidentJournal")
      request_id = source.incident_request_id
      journal_id = source.id
    end

    respond_to do |format|
      if attachment.destroy
        Icm::IncidentHistory.create({:request_id => request_id,
                                     :journal_id=> journal_id,
                                     :property_key=> "remove_attachment",
                                     :old_value=> name,
                                     :new_value=> ""})
        format.js {render :after_remove_attachment}
      else
        format.js {render ""}
      end
    end
  end

  private
  def process_change_attributes(attributes,new_value,old_value,ref_request)
    attributes.each do |key|
      ovalue = old_value.send(key.to_s)
      nvalue = new_value.send(key.to_s)
      hi = Icm::IncidentHistory.create({:request_id=> ref_request,
                                     :property_key=>key.to_s,
                                     :old_value=>ovalue,
                                     :new_value=>nvalue}) if !ovalue.eql?(nvalue)
    end
  end

  def prepared_for_create(incident_request)
    incident_request.submitted_by = Irm::Person.current.id
    incident_request.submitted_date = Time.now
    incident_request.last_request_date = Time.now
    incident_request.last_response_date = 1.minute.ago
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

    if limit_device?
      incident_request.summary = "<pre>"+incident_request.summary+"</pre>"
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

  def validate_files(ref_request)
    flash[:notice] = nil
    now = 0
    flag = true
    params[:files].delete_if {|key, value| value[:file].nil? or value[:file].original_filename.blank? }
    if params[:files] and params[:files].size > 0
      flag, now = Irm::AttachmentVersion.validates_repeat?(params[:files])
    else
      now = I18n.t(:error_file_upload_empty)
    end
    return false, now unless flag
    params[:files].each do |key,value|
      next unless value[:file] && value[:file].original_filename.present?
      flag, now = Irm::AttachmentVersion.validates?(value[:file], Irm::SystemParametersManager.upload_file_limit)
      return false, now unless flag
    end if params[:files]
    return true, now
  rescue
    return false, now
  end

  def check_support_group(support_group_id,system_id)
    Icm::SupportGroup.where(:oncall_flag=>Irm::Constant::SYS_YES).assignable.query(support_group_id).first.present?
  end
end
