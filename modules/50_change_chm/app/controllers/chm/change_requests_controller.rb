class Chm::ChangeRequestsController < ApplicationController
  layout "bootstrap_application_full"
  # GET /statuses
  # GET /statuses.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  {
        @change_requests = Chm::ChangeRequest.all
        render :xml => @change_requests
      }
    end

  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])
    @request_files = Chm::ChangeRequest.request_files(@change_request.id)
    @change_journals = @change_request.change_journals.list_all
    @change_journal = @change_request.change_journals.build(:replied_by=>Irm::Person.current.id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @change_request }
      format.pdf  {
        @change_plan_types = Chm::ChangePlanType.multilingual.enabled
        @grouped_change_plans={}
        change_plans =  @change_request.change_plans.list_all
        @change_plan_types.each do |change_plan_type|
          change_plan = change_plans.detect{|i| i.change_plan_type_id.eql?(change_plan_type.id)}
          change_plan = Chm::ChangePlan.new(:change_plan_type_id=>change_plan_type.id,:change_request_id=>@change_request.id) unless change_plan.present?
          @grouped_change_plans[change_plan_type.id] = change_plan
        end
        render :pdf => @change_request.title,
               :print_media_type => true,
               :encoding => 'utf-8',
               :zoom => 0.8
      }
    end
  end


  # GET /statuses/1
  # GET /statuses/1.xml
  def show_incident
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @change_request }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show_config
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @change_request }
    end
  end


  # GET /statuses/1
  # GET /statuses/1.xml
  def show_plan
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    @change_plan_types = Chm::ChangePlanType.multilingual.enabled

    @grouped_change_plans={}

    change_plans =  @change_request.change_plans.list_all

    @change_plan_types.each do |change_plan_type|
      change_plan = change_plans.detect{|i| i.change_plan_type_id.eql?(change_plan_type.id)}
      change_plan = Chm::ChangePlan.new(:change_plan_type_id=>change_plan_type.id,:change_request_id=>@change_request.id) unless change_plan.present?
      @grouped_change_plans[change_plan_type.id] = change_plan
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @change_request }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show_implement
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @change_request }
    end
  end



  # GET /statuses/1
  # GET /statuses/1.xml
  def show_approve
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @change_request }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @change_request = Chm::ChangeRequest.new(params[:chm_change_request]||{})

    # 设定默认成请求人
    @change_request.requested_by = Irm::Person.current.id unless  @change_request.requested_by.present?

    unless @change_request.change_status_id.present?
      @change_request.change_status_id = Chm::ChangeStatus.default_id
    end

    unless @change_request.change_impact_id.present?
      @change_request.change_impact_id = Chm::ChangeImpact.default_id
    end

    unless @change_request.change_urgency_id.present?
      @change_request.change_urgency_id = Chm::ChangeUrgency.default_id
    end

    unless @change_request.change_urgency_id.present?
      @change_request.change_urgency_id = Chm::ChangeUrgency.default_id
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_request }
    end
  end


  def incident_new
    incident_request = Icm::IncidentRequest.find(params[:request_id])

    # 复制 事故单上的字段信息
    @change_request = Chm::ChangeRequest.new(params[:chm_change_request]||{})

    @change_request.requested_by = incident_request.requested_by

    @change_request.external_system_id = incident_request.external_system_id

    @change_request.category_id = incident_request.incident_category_id

    @change_request.sub_category_id = incident_request.incident_sub_category_id

    @change_request.title= incident_request.title

    @change_request.summary= incident_request.summary

    @change_request.contact_id = incident_request.contact_id

    @change_request.contact_number= incident_request.contact_number

    @change_request.incident_request_id = incident_request.id

    # 设定默认成请求人
    @change_request.requested_by = Irm::Person.current.id unless  @change_request.requested_by.present?

    unless @change_request.change_status_id.present?
      @change_request.change_status_id = Chm::ChangeStatus.default_id
    end

    unless @change_request.change_impact_id.present?
      @change_request.change_impact_id = Chm::ChangeImpact.default_id
    end

    unless @change_request.change_urgency_id.present?
      @change_request.change_urgency_id = Chm::ChangeUrgency.default_id
    end

    unless @change_request.change_urgency_id.present?
      @change_request.change_urgency_id = Chm::ChangeUrgency.default_id
    end

    respond_to do |format|
      format.html { render :action => "new"}
      format.xml  { render :xml => @change_request }
    end
  end


  # GET /statuses/1/edit
  def edit
    @change_request = Chm::ChangeRequest.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_request = Chm::ChangeRequest.new(params[:chm_change_request])

    respond_to do |format|
      if @change_request.save
        process_files(@change_request)
        Icm::IncidentRequest.find(@change_request.incident_request_id).process_change(@change_request.id) if @change_request.incident_request_id.present?

        format.html { redirect_to({:action => "show",:id=>@change_request.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @change_request, :status => :created, :location => @change_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @change_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_request = Chm::ChangeRequest.find(params[:id])

    respond_to do |format|
      if @change_request.update_attributes(params[:chm_change_request])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit",:layout => "application_full"}
        format.xml  { render :xml => @change_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_request = Chm::ChangeRequest.find(params[:id])
    @change_request.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end


  def get_data
    return_columns = [:request_number,
                      :organization_id,
                      :organization_id_label,
                      :title,
                      :change_status_id,
                      :change_status_id_label,
                      :requested_by,
                      :requested_by_label,
                      :support_group_id,
                      :support_group_id_label,
                      :support_person_id,
                      :support_person_id_label,
                      :external_system_id,
                      :external_system_id_label,
                      :category_id,:category_id_label,
                      :change_priority_id,
                      :change_priority_id_label,
                      :submitted_date]
    bo = Irm::BusinessObject.where(:business_object_code=>"CHM_CHANGE_REQUESTS").first

    change_priority_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"change_priority_id")

    change_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true))

    if change_priority_table_alias.present?
      change_requests_scope.order("change_priority_table_alias.weight_values,#{bo.bo_table_name}.submitted_date DESC")
    end

    change_requests_scope = change_requests_scope.match_value("#{bo.bo_table_name}.request_number",params[:request_number])
    change_requests_scope = change_requests_scope.match_value("#{bo.bo_table_name}.title",params[:title])

    respond_to do |format|
      format.json {
        change_requests_scope,count = paginate(change_requests_scope)
        render :json=>to_jsonp(change_requests_scope.to_grid_json(return_columns,count))
      }
      format.html {
        @datas,@count = paginate(change_requests_scope)
      }
      format.xls{
        change_requests = data_filter(change_requests_scope)
        send_data(data_to_xls(change_requests,
                              [{:key=>:request_number,:label=>t(:label_chm_change_request_request_number)},
                               {:key=>:title,:label=>t(:label_chm_change_request_title)},
                               {:key=>:incident_status_id_label,:label=>t(:label_chm_change_request_change_status)},
                               {:key=>:submitted_date,:label=>t(:label_chm_change_request_submitted_date)},
                               {:key=>:external_system_id_label,:label=>t(:label_chm_change_request_external_system)}]
                  ))
      }
    end

  end


  def show_detail
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html { render :layout=>"xhr"}
      format.xml  { render :xml => @change_request }
    end
  end

  private
  def process_files(ref_request)
    @files = []
    params[:files].each do |key,value|
      @files << Irm::AttachmentVersion.create({:source_id=>ref_request.id,
                                               :source_type=>ref_request.class.name,
                                               :data=>value[:file],
                                               :description=>value[:description]}) if(value[:file]&&!value[:file].blank?)
    end if params[:files]
  end
end
