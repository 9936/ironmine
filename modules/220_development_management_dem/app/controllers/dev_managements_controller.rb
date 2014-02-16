class Dem::DevManagementsController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @dev_management = Dem::DevManagement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @dev_management = Dem::DevManagement.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @dev_management = Dem::DevManagement.find(params[:id])
  end

  def create
    @dev_management = Dem::DevManagement.new(params[:dem_dev_management])

    respond_to do |format|
      if @dev_management.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @dev_management = Dem::DevManagement.find(params[:id])

    respond_to do |format|
      if @dev_management.update_attributes(params[:dem_dev_management])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @dev_management = Dem::DevManagement.find(params[:id])
    @dev_management.destroy

    respond_to do |format|
      format.html { redirect_to(dem_dev_management_url) }
      format.xml { head :ok }
    end
  end


  def get_data
    dev_management_scope = Dem::DevManagement.where("1=1").select("*").order("created_at DESC")
    dev_managements, count = paginate(dev_management_scope)
    respond_to do |format|
      format.html {
        @datas = dev_managements
        @count = count
      }
      format.json { render :json => to_jsonp(dev_managements.to_grid_json([:name, :description, :status], count)) }
    end
  end
end
