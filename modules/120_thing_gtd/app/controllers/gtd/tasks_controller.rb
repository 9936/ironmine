class Gtd::TasksController < ApplicationController
  layout "application_full"

  def index

  end

  def get_data
    tasks_scope = Gtd::Task.with_all.with_assigned_person#.with_task_status.with_priority.uncompleted.with_calendar.assigned_to(Irm::Person.current.id)
    #tasks_scope = tasks_scope.with_open#只查询打开的
    tasks_scope = tasks_scope.match_value("#{Gtd::Task.table_name}.name", params[:name])
    tasks,count = paginate(tasks_scope)
    respond_to do |format|
      format.html {
        @datas = tasks
        @count = count
      }
      format.json  {render :json => to_jsonp(tasks.to_grid_json([:name,:start_at,:end_at], count)) }
    end
  end


  def new
    @task = Gtd::Task.new
    respond_to do |format|
      format.html
    end
  end

  def get_assigned_data
    assigned_scope = Irm::Person.enabled.with_external_system(params[:external_system_id]).order("full_name_pinyin")#.offset(210).limit(1)
    assigned_scope = assigned_scope.uniq
    assigned = assigned_scope.collect { |i| {:label => i[:full_name], :value => i.id, :id => i.id} }
    respond_to do |format|
      format.json { render :json => assigned.to_grid_json([:label, :value], assigned.count) }
    end
  end

  def create
    @task = Gtd::Task.new(params[:gtd_task])
    @task.rule = YAML.dump(params[:time_mode_obj])
    respond_to do |format|
      if @task.save
        format.html { redirect_to({:controller=>"gtd/tasks",:action => "index"}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @task = Gtd::Task.find(params[:id])
    @return_url=request.env['HTTP_REFERER']
  end

  def update
    @task = Gtd::Task.find(params[:id])
    @task.rule = YAML.dump(params[:time_mode_obj])
    respond_to do |format|
      if @task.update_attributes(params[:gtd_task])
        format.html { redirect_to({:controller => "gtd/tasks", :action=>"index"}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @task = Gtd::Task.with_all.with_assigned_person.find(params[:id])#with_all.with_task_status.with_calendar.with_priority.where("#{Gtd::Task.table_name}.id = ?", params[:id]).first
  end

  def my_tasks_index

  end

  def my_tasks_get_data
    my_tasks_scope = Gtd::Task.with_all.with_task_status.with_priority.uncompleted.with_calendar.assigned_to(Irm::Person.current.id)
    my_tasks,count = paginate(my_tasks_scope)
    respond_to do |format|
      format.json {render :json => to_jsonp(my_tasks.to_grid_json([:name,:start_at,:end_at,:due_date, :color,:status_code, :assigned_name, :priority_name, :event_status_name], count))}
    end
  end

  def edit_recurrence

  end

  def update_recurrence

  end

  def portlet
      render :layout => false
  end
end