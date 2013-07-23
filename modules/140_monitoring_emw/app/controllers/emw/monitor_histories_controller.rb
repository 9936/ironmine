class Emw::MonitorHistoriesController < ApplicationController
  layout "application_full"

  def index
    @monitor_program = Emw::MonitorProgram.select_all.find(params[:program_id])
  end

  #获取监控方案执行历史数据
  def get_data
    @monitor_program = Emw::MonitorProgram.find(params[:program_id])
    history_scope = Emw::MonitorHistory.select_all.with_program(params[:program_id])
    histories,count = paginate(history_scope)

    respond_to do |format|
      format.html  {
        @datas = histories
        @count = count
      }
    end
  end

  def show
    @monitor_history = Emw::MonitorHistory.select_all.find(params[:id])
    @monitor_program = Emw::MonitorProgram.select_all.find(@monitor_history.monitor_program_id)
  end

end