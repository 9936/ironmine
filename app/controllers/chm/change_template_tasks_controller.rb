class Chm::ChangeTemplateTasksController < ApplicationController

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
    @change_task = Chm::ChangeTask.new(:source_id=>params[:source_id],:source_type=>Chm::ChangeTaskTemplate.name)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change_task_template }
    end
  end

  # GET /statuses/1/edit
  def edit
    @change_task = Chm::ChangeTask.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @change_task = Chm::ChangeTask.new(params[:chm_change_task])

    respond_to do |format|
      if @change_task.save
        format.html { redirect_to({:controller=>"chm/change_task_templates",:action => "show",:id=>@change_task.source_id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @change_task, :status => :created, :location => @change_task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @change_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @change_task = Chm::ChangeTask.find(params[:id])

    respond_to do |format|
      if @change_task.update_attributes(params[:chm_change_task])
        format.html { redirect_to({:controller=>"chm/change_task_templates",:action => "show",:id=>@change_task.source_id}, :notice => t(:successfully_updated)) }
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
    @change_task = Chm::ChangeTask.find(params[:id])
    @change_task.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"chm/change_task_templates",:action => "show",:id=>@change_task.source_id}) }
      format.xml  { head :ok }
    end
  end

end
