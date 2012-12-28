class Irm::DelayedJobsController < ApplicationController

  def index

  end

  def get_data
    @logs = Irm::DelayedJobLog.list_all
    #@logs = @logs.match_value("lvt.meaning",params[:job_status_name]) if params[:job_status_name].present?
    @logs,count = paginate(@logs)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@logs.to_grid_json([:id, :delayed_job_id, :priority, :attempts, :run_at,
                                                             :last_error, :end_at, :failed_at, :handler, :status, :job_status], count))}
      format.html  {
        @count = count
        @datas =@logs
      }
    end
  end

  def item_list
    @log = Irm::DelayedJobLog.list_all.where("delayed_job_id" => params[:delayed_job_id]).first
  end

  def get_item_data
    @item = Irm::DelayedJobLogItem.unscoped.list_all(params[:delayed_job_id])
    @item, count = paginate(@item)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@item.to_grid_json([:created_at, :content, :id, :job_status, :job_status_name], count))}
      format.html  {
        @count = count
        @datas = @item
      }
    end
  end

  def wf_process_job_monitor
    @monitor = Irm::DelayedJobLog.wf_process_job_monitor
  end

  def icm_group_assign_monitor
    @monitor = Irm::DelayedJobLog.icm_group_assign_monitor
  end

  def ir_rule_process_monitor
    @monitor = Irm::DelayedJobLog.ir_rule_process_monitor
  end

  def approval_mail_monitor
    @monitor = Irm::DelayedJobLog.wf_approval_mail_monitor
  end
end
