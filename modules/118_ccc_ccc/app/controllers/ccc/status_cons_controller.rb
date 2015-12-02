class Ccc::StatusConsController < ApplicationController
  layout "setting"
  def index
    @statusCons = Ccc::StatusCon.where("external_system_id = ?",params[:sid])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @statusCons }
    end
  end

  def new
    @statusCon = Ccc::StatusCon.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @statusCon }
    end
  end

  def create
    puts "1111111111111111"
    puts params[:ccc_status_con]
    @statusCon = Ccc::StatusCon.new(params[:ccc_status_con])
    respond_to do |format|
      if @statusCon.valid? && @statusCon.save
        format.html { redirect_to({:action => "index",:sid=>@statusCon.external_system_id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @statusCon, :status => :created, :location => @statusCon }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @statusCon.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @statusCon = Ccc::StatusCon.find(params[:id])
  end

  def update
    @statusCon = Ccc::StatusCon.find(params[:id])

    respond_to do |format|
      if @statusCon.update_attributes(params[:ccc_status_con])
        format.html  { redirect_to({:action => "index",:sid=>@statusCon.external_system_id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=>@statusCon}
      else
        @error = @statusCon
        format.html { render "edit" }
        format.xml  { render :xml => @statusCon.errors, :status => :unprocessable_entity }
        format.json  { render :json => @statusCon.errors}
      end
    end
  end

  def get_data
    puts params[:sid]
    status_con_scope = Ccc::StatusCon.where("external_system_id = ?",params[:sid])
    puts "11111111111111111"
    puts status_con_scope.inspect
    status_con_scope,count = paginate(status_con_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(status_con_scope.to_grid_json([:incident_status_parent_id,
                                                                    :incident_status_children_id,
                                                                    :profile_type_id,
                                                                    :attribute1,
                                                                    :attribute2,
                                                                    :attribute3],count))}
      format.html  {
        @count = count
        @datas = status_con_scope
      }
    end
  end
end
