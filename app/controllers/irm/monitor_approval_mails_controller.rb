class Irm::MonitorApprovalMailsController < ApplicationController
  def index
    @monitor = Irm::DelayedJobLog.wf_approval_mail_monitor
  end
end