class Gtd::TaskWorkbenchesController < ApplicationController
  layout "application_full"

  def index
    @filter_params = {}
    if cookies[:task_rule_types].present?
      @filter_params[:rule_types] = cookies[:task_rule_types].split(",")
    end

    if cookies[:task_status].present?
      @filter_params[:status] = cookies[:task_status].split(",")
    end

    if cookies[:task_filter].present?
      @filter_params[:filter] = cookies[:task_filter]
    end

    if cookies[:date_value].present?
      @filter_params[:date] = Time.zone.at(cookies[:date_value].first(10).to_i).strftime('%Y-%m-%d')
    else
      @filter_params[:date] = Time.zone.now.strftime('%Y-%m-%d')
    end

  end

  def today
    @filter_params = {}
    if cookies[:task_rule_types].present?
      @filter_params[:rule_types] = cookies[:task_rule_types].split(",")
    end

    if cookies[:task_status].present?
      @filter_params[:status] = cookies[:task_status].split(",")
    end
  end

  def today_instance_data
    if cookies[:task_rule_types].present?
      params[:rule_types] = cookies[:task_rule_types].split(",")
    end

    if cookies[:task_status].present?
      params[:status] = cookies[:task_status].split(",")
    end
    tasks_scope = Gtd::Task.with_all.with_assigned_person.query_instances_by_day(Time.zone.now.strftime('%Y-%m-%d'))
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

  def done
    @task_instance = Gtd::Task.find(params[:id])
    render :layout => false
  end

  def show
    @task_instance = Gtd::Task.with_all.with_assigned_person.find(params[:id])
    if @task_instance.parent_id.present?
      @task =  Gtd::Task.with_all.with_assigned_person.find(@task_instance.parent_id)
    end
  end

  def update_done
    @task_instance = Gtd::Task.find(params[:id])
    @task_instance.update_attributes(params[:gtd_task])
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
    if cookies[:task_rule_types].present?
      params[:rule_types] = cookies[:task_rule_types].split(",")
    end

    if cookies[:task_status].present?
      params[:status] = cookies[:task_status].split(",")
    end

    if cookies[:task_filter].present?
      params[:filter] = cookies[:task_filter]
    end

    if cookies[:date_value].present?
      params[:date] = cookies[:date_value]
    end


    if params[:date].present?
      date = Time.zone.at(params[:date].first(10).to_i).change(:hour=>0,:min=>0,:sec=>0)
    else
      date = Time.zone.now.change(:hour=>0,:min=>0,:sec=>0)
    end

    #默认为分派给我的
    params[:filter] ||= "zero"

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