class Ndm::DevManagementsController < ApplicationController
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
    @dev_management = Ndm::DevManagement.select_all.find(params[:id])
    #@dev_phases = Ndm::DevPhase.with_phase_status(language).with_template.
    #    where("dev_management_id = ?", @dev_management.id).
    #    order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def new
    @dev_management = Ndm::DevManagement.new

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def edit
    @dev_management = Ndm::DevManagement.find(params[:id])
    #@dev_phases = Ndm::DevPhase.with_template.
    #    where("dev_management_id = ?", @dev_management.id).
    #    order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def create
    @dev_management = Ndm::DevManagement.new(params[:ndm_dev_management])
    @dev_management.no = Irm::Sequence.nextval(Ndm::DevManagement.name)
    respond_to do |format|
      if @dev_management.save
        @dev_management.update_dev_status
        #@dev_management.update_trigger
        if params[:save_back]
          format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        else params[:save_continue]
          format.html { redirect_to({:action => "edit", :id => @dev_management.id}, :notice => t(:successfully_updated)) }
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @dev_management = Ndm::DevManagement.find(params[:id])
    #dev_phases = params[:dev_phase]

    respond_to do |format|
      if @dev_management.update_attributes(params[:ndm_dev_management])
        @dev_management.update_dev_status
        #dev_phases.each do |dp|
        #  Ndm::DevPhase.find(dp[0]).update_attributes(dp[1])
        #end if dev_phases
        #@dev_management.update_trigger
        if params[:save_back]
          format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        else params[:save_continue]
          format.html { redirect_to({:action => "edit", :id => params[:id]}, :notice => t(:successfully_updated)) }
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @dev_management = Ndm::DevManagement.find(params[:id])
    @dev_management.destroy

    respond_to do |format|
      format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      format.xml { head :ok }
    end
  end


  def get_data
    language = I18n.locale
    dev_management_scope = Ndm::DevManagement.
        with_method(language).
        with_project_relation(Irm::Person.current.id).
        with_dev_difficulty(language).
        with_dev_type(language).
        with_priority(language).
        with_status(language, "gd_status").
        with_status(language, "fd_status").
        with_status(language, "fdr_status").
        with_status(language, "td_status").
        with_status(language, "co_status").
        with_status(language, "te_status").
        with_status(language, "si_status").
        with_status(language, "at_status").
        with_status(language, "go_status").
        select_all.order("(no + 0) ASC")
    dev_management_scope = dev_management_scope.
        where("#{Ndm::DevManagement.table_name}.project IN (?)",
              params[:project_params][:project_id]) if params[:project_params] && params[:project_params][:project_id].first.present?

    dev_management_scope = dev_management_scope.
        where("#{Ndm::DevManagement.table_name}.no LIKE ?",
              '%' + params[:project_params][:no] + '%') if params[:project_params] && params[:project_params][:no].present?

    dev_management_scope = dev_management_scope.
        where("#{Ndm::DevManagement.table_name}.name LIKE ?",
              '%' + params[:project_params][:name] + '%') if params[:project_params] && params[:project_params][:name].present?

    dev_management_scope = dev_management_scope.
        where("#{Ndm::DevManagement.table_name}.dev_status LIKE ?",
              '%' + params[:project_params][:dev_status] + '%') if params[:project_params] && params[:project_params][:dev_status].present?

    dev_management_scope = dev_management_scope.
        where("vtype.meaning LIKE ?",
              '%' + params[:project_params][:dev_type] + '%') if params[:project_params] && params[:project_params][:dev_type].present?

    dev_management_scope = dev_management_scope.
        where("vpriority.meaning LIKE ?",
              '%' + params[:project_params][:priority] + '%') if params[:project_params] && params[:project_params][:priority].present?

    dev_management_scope = dev_management_scope.
        where("vmethod.meaning LIKE ?",
              '%' + params[:project_params][:method] + '%') if params[:project_params] && params[:project_params][:method].present?

    dev_management_scope = dev_management_scope.
        where("vdifficulty.meaning LIKE ?",
              '%' + params[:project_params][:dev_difficulty] + '%') if params[:project_params] && params[:project_params][:dev_difficulty].present?

    begin
    dev_management_scope = dev_management_scope.
        where("date_format(#{Ndm::DevManagement.table_name}.require_date, '%Y-%m-%d') >= ?",
              Date.strptime("#{params[:project_params][:date_from]}", '%Y-%m-%d').strftime("%Y-%m-%d")) if params[:project_params] && params[:project_params][:date_from].present?
    rescue
      nil
    end

    begin
    dev_management_scope = dev_management_scope.
        where("date_format(#{Ndm::DevManagement.table_name}.require_date, '%Y-%m-%d') <= ?",
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
    dp = Ndm::DevPhase.new({:dev_management_id => params[:dev_management_id],
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
    @dev_management = Ndm::DevManagement.find(params[:id])
    @dev_phases = Ndm::DevPhase.with_template.where("dev_management_id = ?", @dev_management.id).order("display_sequence ASC, created_at ASC")

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def update_phase_sequence
    @dev_management = Ndm::DevManagement.find(params[:id])
    dev_phases = params[:dev_phase]

    respond_to do |format|
      dev_phases.each do |dp|
        Ndm::DevPhase.find(dp[0]).update_attributes(dp[1])
      end if dev_phases
      @dev_management.update_trigger
      format.html { redirect_to({:action => "show", :id => params[:id]}, :notice => t(:successfully_updated)) }
    end
  end

  def phase_edit
    language = I18n.locale
    @phase_code = params[:phase_code]
    @dev_management = Ndm::DevManagement.select_all.
        with_method(language).
        with_project_relation(Irm::Person.current.id).
        with_dev_difficulty(language).
        with_dev_type(language).
        with_priority(language).find(params[:dev_management_id])

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def phase_update
    @dev_management = Ndm::DevManagement.find(params[:id])

    respond_to do |format|
      if @dev_management.update_attributes(params[:ndm_dev_management])
        @dev_management.update_dev_status
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      else
        format.html { render :action => "phase_edit" }
      end
    end
  end
end
