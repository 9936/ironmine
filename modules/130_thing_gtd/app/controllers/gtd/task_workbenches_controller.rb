class Gtd::TaskWorkbenchesController < ApplicationController
  layout "application_full"

  def index
    @task_instance = Gtd::Task.last
    #tasks = Gtd::Task.all
    #tasks.each do |task|
    #  task.generate_task_instances(Time.now)
    #end

  end

  def edit
    @task_instance = Gtd::Task.find(params[:id])
    render :layout => false
  end

  def update
    @task_instance = Gtd::Task.find(params[:id])
    @task_instance.update_attributes(params[:gtd_task])
  end


  def get_instance_data
    if params[:date].present?
      date = Time.zone.at(params[:date].first(10).to_i).change(:hour=>0,:min=>0,:sec=>0)
    else
      date = Time.zone.now.change(:hour=>0,:min=>0,:sec=>0)
    end

    params[:filter] ||= "0"

    tasks_scope = Gtd::Task.with_all.with_assigned_person.query_instances_by_day(date)
    tasks_scope = tasks_scope.with_filter(params[:filter])

    #对状态进行过滤
    if params[:status] && params[:status].any? && !params[:status].include?("ALL")
      tasks_scope = tasks_scope.with_status(params[:status])
    end
    #对类型进行过滤
    if params[:rule_types] && params[:rule_types].any? && !params[:rule_types].include?("ALL")
      tasks_scope = tasks_scope.with_rule_type(params[:rule_types])
    end

    tasks,count = paginate(tasks_scope)
    respond_to do |format|
      format.html {
        @datas = tasks
        @count = count
      }

    end
  end

end