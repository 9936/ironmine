module Gtd::TaskWorkbenchesHelper
  #获取可用的状态列表
  def available_task_status
    [[t(:label_gtd_task_workbench_status_waiting), "WAITING"],
     [t(:label_gtd_task_workbench_status_process), "PROCESS"],
     [t(:label_gtd_task_workbench_status_done), "DONE"]
    ]
  end

end