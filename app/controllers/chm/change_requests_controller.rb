class Chm::ChangeRequestsController < ApplicationController
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

    respond_to do |format|
      format.html { render :layout=>"application_right"}
      format.xml  { render :xml => @change_request }
    end
  end


  # GET /statuses/1
  # GET /statuses/1.xml
  def show_incident
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html { render :layout=>"application_right"}
      format.xml  { render :xml => @change_request }
    end
  end


  # GET /statuses/1
  # GET /statuses/1.xml
  def show_plan
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html { render :layout=>"application_right"}
      format.xml  { render :xml => @change_request }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show_implement
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html { render :layout=>"application_right"}
      format.xml  { render :xml => @change_request }
    end
  end



  # GET /statuses/1
  # GET /statuses/1.xml
  def show_approve
    @change_request = Chm::ChangeRequest.list_all.find(params[:id])

    respond_to do |format|
      format.html { render :layout=>"application_right"}
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

  # GET /statuses/1/edit
  def edit
    @change_request = Chm::ChangeRequest.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_request = Chm::ChangeRequest.new(params[:chm_change_request])

    respond_to do |format|
      if @change_request.save
        process_files(@change_request)
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
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
        format.html { render :action => "edit" }
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
        render_html_data_table
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
