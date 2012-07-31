class Chm::ChangeTasksController < ApplicationController
  layout "bootstrap_application_full"
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
    options = {}
    if params[:phase_id].present?
      options.merge!({:change_task_phase_id=>params[:phase_id]})
    end
    @change_task = Chm::ChangeTask.new({:source_id=>params[:source_id],:source_type=>Chm::ChangeRequest.name}.merge(options))

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
      if @change_task.valid?
        @change_task.create_from_depend_task_ids(params[:depend_tasks])
        @change_task.save
        format.html { redirect_to({:controller=>"chm/change_requests",:action => "show_implement",:id=>@change_task.source_id}, :notice => t(:successfully_created)) }
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
    @change_task.attributes = params[:chm_change_task]
    respond_to do |format|
      if @change_task.valid?
        @change_task.create_from_depend_task_ids(params[:depend_tasks])
        @change_task.save
        format.html { redirect_to({:controller=>"chm/change_requests",:action => "show_implement",:id=>@change_task.source_id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
        format.json { render :json=> @change_task.to_json }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @change_task_template.errors, :status => :unprocessable_entity }
        format.json { render :json=> @change_task.errors.to_json }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @change_task = Chm::ChangeTask.find(params[:id])
    @change_task.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"chm/change_requests",:action => "show_implement",:id=>@change_task.source_id}) }
      format.xml  { head :ok }
    end
  end


  def template_new
    @change_task = Chm::ChangeTask.new(:source_id=>params[:source_id],:source_type=>Chm::ChangeRequest.name)
  end

  def template_create
    @change_task = Chm::ChangeTask.new(params[:chm_change_task])
    change_task_template = Chm::ChangeTaskTemplate.find(@change_task.change_task_phase_id)
    Chm::ChangeTask.where(:source_id=>change_task_template.id,:source_type=>change_task_template.class.name).enabled.each do |task|
      Chm::ChangeTask.create(:source_id=>@change_task.source_id,
                             :source_type=>@change_task.source_type,
                             :name=>task.name,
                             :message=>task.message,
                             :description=>task.description,
                             :status=>task.status,
                             :support_group_id=>task.support_group_id,
                             :support_person_id=>task.support_person_id,
                             :change_task_phase_id=>task.change_task_phase_id)
    end

    respond_to do |format|
      format.html { redirect_to({:controller=>"chm/change_requests",:action => "show_implement",:id=>@change_task.source_id}) }
      format.xml  { head :ok }
    end
  end

end
