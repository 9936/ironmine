class Irm::DelayedJobsController < ApplicationController

  def index

  end

  def get_data
    @log = Irm::DelayedJobLog.list_all
    @log,count = paginate(@log)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@log.to_grid_json([:id, :delayed_job_id, :priority, :attempts, :run_at,
                                                             :last_error, :end_at, :failed_at, :handler, :status, :job_status], count))}
    end
  end

  def item_list
    @log = Irm::DelayedJobLog.list_all.where("delayed_job_id" => params[:delayed_job_id]).first
  end

  def get_item_data
    @item = Irm::DelayedJobLogItem.list_all(params[:delayed_job_id])
    @item, count = paginate(@item)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@item.to_grid_json([:created_at, :content, :id, :job_status, :job_status_name], count))}
    end
  end
end
