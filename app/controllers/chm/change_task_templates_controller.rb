class Chm::ChangeTaskTemplatesController < ApplicationController
  # GET /statuses
  # GET /statuses.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { @change_task_templates = Chm::ChaneTaskTemplate.all
                    render :xml => @change_task_templates 
      }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @change_task_template = Chm::ChangeTaskTemplate.multilingual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @change_task_template }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @change_task_template = Chm::ChangeTaskTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_task_template }
    end
  end

  # GET /statuses/1/edit
  def edit
    @change_task_template = Chm::ChangeTaskTemplate.multilingual.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_task_template = Chm::ChangeTaskTemplate.new(params[:chm_change_task_template])

    respond_to do |format|
      if @change_task_template.save
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @change_task_template, :status => :created, :location => @change_task_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @change_task_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_task_template = Chm::ChangeTaskTemplate.find(params[:id])

    respond_to do |format|
      if @change_task_template.update_attributes(params[:chm_change_task_template])
        format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_task_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_task_template = Chm::ChangeTaskTemplate.find(params[:id])
    @change_task_template.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end

  def multilingual_edit
    @change_task_template = Chm::ChangeTaskTemplate.find(params[:id])
  end

  def multilingual_update
    @change_task_template = Chm::ChangeTaskTemplate.find(params[:id])
    @change_task_template.not_auto_mult=true
    respond_to do |format|
      if @change_task_template.update_attributes(params[:chm_change_task_template])
        format.html { redirect_to({:action => "show"}, :notice => 'Status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_task_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_data
    change_task_templates_scope = Chm::ChangeTaskTemplate.multilingual.order("#{Chm::ChangeTaskTemplate.table_name}.created_at desc")
    change_task_templates_scope = change_task_templates_scope.match_value("#{Chm::ChangeTaskTemplate.table_name}.name",params[:name])
    change_task_templates_scope = change_task_templates_scope.match_value("#{Chm::ChangeTaskTemplate.table_name}.code",params[:code])
    change_task_templates,count = paginate(change_task_templates_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(change_task_templates.to_grid_json([:name,:code,:description,:status_meaning],count))}
    end
  end


  def show_tasks
    @change_task_template = Chm::ChangeTaskTemplate.multilingual.find(params[:id])
  end

end
