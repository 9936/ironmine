class Dem::DevManagementsController < ApplicationController
  def index
    @project_params = params[:project_params] if params[:project_params]

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def sindex
    @project_params = params[:project_params] if params[:project_params]

    respond_to do |format|
      #format.html { render :layout => "application_full"}
      format.html { render :action => "index",  :layout => "application_full"}
    end
  end

  def show
    language = I18n.locale
    @dev_management = Dem::DevManagement.
        with_method(language).
        with_module(language).
        with_dev_difficulty(language).
        select_all.with_related_project.with_project.find(params[:id])
    @dev_phases = Dem::DevPhase.with_phase_status(language).with_template.
        where("dev_management_id = ?", @dev_management.id).
        order("display_sequence ASC, created_at ASC")

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
    @dev_phases = Dem::DevPhase.with_template.
        where("dev_management_id = ?", @dev_management.id).
        order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def create
    @dev_management = Dem::DevManagement.new(params[:dem_dev_management])

    respond_to do |format|
      if @dev_management.save
        @dev_management.update_trigger
        if params[:save_back]
          format.html { redirect_to({:action => "show", :id => @dev_management.id}, :notice => t(:successfully_updated)) }
        else params[:save_continue]
          format.html { redirect_to({:action => "edit", :id => @dev_management.id}, :notice => t(:successfully_updated)) }
        end
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
        @dev_management.update_trigger
        if params[:save_back]
          format.html { redirect_to({:action => "show", :id => params[:id]}, :notice => t(:successfully_updated)) }
        else params[:save_continue]
          format.html { redirect_to({:action => "edit", :id => params[:id]}, :notice => t(:successfully_updated)) }
        end
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
    language = I18n.locale
    dev_management_scope = Dem::DevManagement.
        with_method(language).
        with_module(language).
        with_project.select_all.order("(develop_id + 0) ASC")
    dev_management_scope = dev_management_scope.
        where("#{Dem::DevManagement.table_name}.project_id IN (?)",
              params[:project_params][:project_id]) if params[:project_params] && params[:project_params][:project_id].first.present?

    dev_management_scope = dev_management_scope.
        where("#{Dem::DevManagement.table_name}.system LIKE ?",
              '%' + params[:project_params][:system] + '%') if params[:project_params] && params[:project_params][:system].present?

    dev_management_scope = dev_management_scope.
        where("#{Dem::DevManagement.table_name}.module LIKE ?",
              '%' + params[:project_params][:module] + '%') if params[:project_params] && params[:project_params][:module].present?

    dev_management_scope = dev_management_scope.
        where("#{Dem::DevManagement.table_name}.dev_status LIKE ?",
              '%' + params[:project_params][:dev_status] + '%') if params[:project_params] && params[:project_params][:dev_status].present?

    dev_management_scope = dev_management_scope.
        where("#{Dem::DevManagement.table_name}.owner LIKE ?",
              '%' + params[:project_params][:owner] + '%') if params[:project_params] && params[:project_params][:owner].present?

    dev_management_scope = dev_management_scope.
        where("#{Dem::DevManagement.table_name}.owner LIKE ?",
              '%' + params[:project_params][:risk_class] + '%') if params[:project_params] && params[:project_params][:risk_class].present?

    begin
    dev_management_scope = dev_management_scope.
        where("date_format(#{Dem::DevManagement.table_name}.require_date, '%Y-%m-%d') >= ?",
              Date.strptime("#{params[:project_params][:date_from]}", '%Y-%m-%d').strftime("%Y-%m-%d")) if params[:project_params] && params[:project_params][:date_from].present?
    rescue
      nil
    end

    begin
    dev_management_scope = dev_management_scope.
        where("date_format(#{Dem::DevManagement.table_name}.require_date, '%Y-%m-%d') <= ?",
              Date.strptime("#{params[:project_params][:date_to]}", '%Y-%m-%d').strftime("%Y-%m-%d")) if params[:project_params] && params[:project_params][:date_to].present?
    rescue
      nil
    end

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
        dp.dev_management.update_trigger
        format.html { redirect_to({:action => "edit", :id => params[:dev_management_id]}, :notice => t(:successfully_created)) }
      else
        format.html { redirect_to({:action => "edit", :id => params[:dev_management_id]}) }
      end
    end
  end

  def edit_phase_sequence
    @dev_management = Dem::DevManagement.find(params[:id])
    @dev_phases = Dem::DevPhase.with_template.where("dev_management_id = ?", @dev_management.id).order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def update_phase_sequence
    @dev_management = Dem::DevManagement.find(params[:id])
    dev_phases = params[:dev_phase]

    respond_to do |format|
      dev_phases.each do |dp|
        Dem::DevPhase.find(dp[0]).update_attributes(dp[1])
      end if dev_phases
      @dev_management.update_trigger
      format.html { redirect_to({:action => "show", :id => params[:id]}, :notice => t(:successfully_updated)) }
    end
  end
end
