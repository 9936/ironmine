class Ndm::ProjectsController < ApplicationController
  def index
    respond_to do |format|
      format.html  
    end
  end

  def show
    respond_to do |format|
      format.html  
    end
  end

  def new
    @project = Ndm::Project.new

    respond_to do |format|
      format.html  
    end
  end

  def edit
    @project = Ndm::Project.find(params[:id])
    respond_to do |format|
      format.html  
    end
  end

  def create
    @project = Ndm::Project.new(params[:ndm_project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @project = Ndm::Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:ndm_project])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @project = Ndm::Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(dem_project_url) }
      format.xml { head :ok }
    end
  end


  def get_data
    project_scope = Ndm::Project.select_all.order("created_at DESC")
    projects, count = paginate(project_scope)
    respond_to do |format|
      format.html {
        @datas = projects
        @count = count
      }
      format.json { render :json => to_jsonp(projects.to_grid_json([:name, :description, :status], count)) }
    end
  end
end
