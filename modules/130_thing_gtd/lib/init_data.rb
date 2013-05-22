#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:TASK=================================
  map.function_group :task, {
      :en => {:name => "Tasks", :description => "Task"},
      :zh => {:name => "任务", :description => "任务"}
  }
  map.function_group :task, {
      :zone_code => "TASK",
      :controller => "gtd/task_workbenches",
      :action => "today"}
  map.function_group :task, {
      :children => {
          :task_define => {
              :en => {:name => "Task Management", :description => "Task Management"},
              :zh => {:name => "日常保障工作管理", :description => "日常保障工作管理"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
               ##"edit_recurrence", "update_recurrence", "my_tasks_get_data", "my_tasks_index","get_assigned_data",
              "gtd/tasks" => ["create","update", "edit", "get_data", "index", "new", "show", "get_calendar_data"]
          },
          :task_personal => {
              :en => {:name => "Personal Task", :description => "Personal Task"},
              :zh => {:name => "个人日常保障工作", :description => "个人日常保障工作"},
              :default_flag => "Y",
              :login_flag => "N",
              :public_flag => "N",
              "gtd/task_workbenches" => ["edit", "update","today","today_instance_data",
                                           "done", "update_done", "show"]
          },
          :task_admin => {
              :en => {:name => "Task Monitor", :description => "Task Monitor"},
              :zh => {:name => "日常保障工作监控", :description => "日常保障工作监控"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
               ##"edit_recurrence", "update_recurrence", "my_tasks_get_data", "my_tasks_index","get_assigned_data",
              "gtd/task_workbenches" => ["index","get_instance_data", "edit", "update"]
          }
      }
  }
  ##=================================END:TASK=================================

end