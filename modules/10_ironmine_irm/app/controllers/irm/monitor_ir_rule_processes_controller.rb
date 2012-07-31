class Irm::MonitorIrRuleProcessesController < ApplicationController
  def index
    @monitor = Irm::DelayedJobLog.ir_rule_process_monitor
  end
end