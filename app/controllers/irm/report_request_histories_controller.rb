class Irm::ReportRequestHistoriesController < ApplicationController
  def index

    respond_to do |format|
      format.html
    end
  end

  def get_data
    histories_scope = Irm::ReportRequestHistory.list_all.order("#{Irm::ReportRequestHistory.table_name}.created_at desc")

    respond_to do |format|
      format.json {
        histories_scope,count = paginate(histories_scope)
        render :json=>to_jsonp(histories_scope.to_grid_json([:report_name,
                                                             :executed_name,
                                                           :created_at,
                                                           :execute_type,
                                                           :start_at,:end_at,:elapse],count))}
    end
  end


end
