class Mam::MastersController < ApplicationController
  layout 'application'
  # GET /incident_requests
  # GET /incident_requests.xml
  def index
    session[:_view_filter_id] = params[:filter_id] if params[:filter_id]
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
    end
  end

  # GET /incident_requests/1
  # GET /incident_requests/1.xml
  def show


    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @master }
    end
  end

  # GET /incident_requests/new
  # GET /incident_requests/new.xml
  def new
    @incident_request = Icm::IncidentRequest.new(({:requested_by => Irm::Person.current.id}).merge(params[:icm_incident_request]||{}))
    if params[:source_id].present? and params[:relation_type].present?
      @source_incident_request = Icm::IncidentRequest.list_all.find(params[:source_id])
    end
    @return_url=request.env['HTTP_REFERER']
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
      format.xml { render :xml => @incident_request }
    end
  end

  def new_item

  end

  def create_item

  end

  def new_scs

  end

  def create_scs

  end

  def new_urs

  end

  def create_urs

  end

  # GET /incident_rsolr_searchequests/1/edit
  def edit
    @incident_request = Icm::IncidentRequest.list_all.query(params[:id])
    @incident_request = check_incident_request_permission(@incident_request)
    respond_to do |format|
      format.html { render :layout => "application_full" } # new.html.erb
      format.xml { render :xml => @incident_request }
    end
  end

  def get_data
    return_columns = [:master_number,
                      :master_type,
                      :master_type_label,
                      :system_id,
                      :system_id_label,
                      :submitted_by,
                      :submitted_by_label,
                      :support_group_id,
                      :support_group_id_label,
                      :support_person_id,
                      :support_person_id_label]
    bo = Irm::BusinessObject.where(:business_object_code => "MAM_MASTERS").first

    masters_scope = eval(bo.generate_query_by_attributes(return_columns, true))

    if params[:order_name]
      order_value = params[:order_value] ? params[:order_value] : "DESC"
      masters_scope = masters_scope.order("#{params[:order_name]} #{order_value}")
    else
      masters_scope = masters_scope.order("updated_at DESC")
    end

    respond_to do |format|
      format.json {
        masters, count = paginate(masters_scope)
        render :json => to_json(masters.to_grid_json(return_columns, count))
      }
      format.html {
        @datas, @count = paginate(masters_scope)
      }
    end
  end

end
