class Dem::DevPhaseTemplatesController < ApplicationController
  def index
    respond_to do |format|
      format.html  
    end
  end

  def show
    @phase_template = Dem::DevPhaseTemplate.find(params[:id])

    respond_to do |format|
      format.html  
    end
  end

  def new
    @phase_template = Dem::DevPhaseTemplate.new

    respond_to do |format|
      format.html  
    end
  end

  def edit
    @phase_template = Dem::DevPhaseTemplate.find(params[:id])
    respond_to do |format|
      format.html  
    end
  end

  def create
    @phase_template = Dem::DevPhaseTemplate.new(params[:dem_dev_phase_template])
    @phase_template.code = Irm::Sequence.nextval(Dem::DevPhaseTemplate.name, Irm::Person.current.opu_id)

    respond_to do |format|
      if @phase_template.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @phase_template = Dem::DevPhaseTemplate.find(params[:id])

    respond_to do |format|
      if @phase_template.update_attributes(params[:dem_dev_phase_template])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @phase_template = Dem::DevPhaseTemplate.find(params[:id])
    @phase_template.destroy

    respond_to do |format|
      format.html { redirect_to(dem_dev_management_url) }
      format.xml { head :ok }
    end
  end


  def get_data
    dev_phase_template_scope = Dem::DevPhaseTemplate.where("1=1").select("*").order("created_at DESC")
    dev_phase_templates, count = paginate(dev_phase_template_scope)
    respond_to do |format|
      format.html {
        @datas = dev_phase_templates
        @count = count
      }
      format.json { render :json => to_jsonp(dev_phase_templates.to_grid_json([:name, :description, :status], count)) }
    end
  end
end
