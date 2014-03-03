class Dem::DevManagementsController < ApplicationController
  def index
    @project_params = params[:project_params] if params[:project_params]

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def show
    @dev_management = Dem::DevManagement.select_all.with_related_project.with_project.find(params[:id])
    @dev_phases = Dem::DevPhase.with_template.where("dev_management_id = ?", @dev_management.id)

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def new
    @dev_management = Dem::DevManagement.new

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def edit
    @dev_management = Dem::DevManagement.find(params[:id])
    @dev_phases = Dem::DevPhase.with_template.where("dev_management_id = ?", @dev_management.id).order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
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
    dev_phases = params[:dev_phase]

    respond_to do |format|
      if @dev_management.update_attributes(params[:dem_dev_management])
        dev_phases.each do |dp|
          Dem::DevPhase.find(dp[0]).update_attributes(dp[1])
        end if dev_phases
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
      format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      format.xml { head :ok }
    end
  end


  def get_data
    dev_management_scope = Dem::DevManagement.with_project.select_all.order("created_at DESC")
    dev_management_scope = dev_management_scope.where("#{Dem::DevManagement.table_name}.project_id IN (?)", params[:project_params][:project_id]) if params[:project_params] && params[:project_params][:project_id].first.present?
    dev_managements, count = paginate(dev_management_scope)
    respond_to do |format|
      format.html {
        @datas = dev_managements
        @count = count
      }
      format.json { render :json => to_jsonp(dev_managements.to_grid_json([:name, :description, :status], count)) }
    end
  end

  def create_phase
    dp = Dem::DevPhase.new({:dev_management_id => params[:dev_management_id],
                       :dev_phase_template_id => params[:dev_phase_template_id],
                       :display_sequence => 10})
    respond_to do |format|
      if dp.save
        format.html { redirect_to({:action => "edit", :id => params[:dev_management_id]}, :notice => t(:successfully_created)) }
      else
        format.html { redirect_to({:action => "edit", :id => params[:dev_management_id]}) }
      end
    end
  end
end
