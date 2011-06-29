class Irm::MonitorIcmGroupAssignsController < ApplicationController
  def index
    @monitor = Irm::DelayedJobLog.icm_group_assign_monitor
  end
end