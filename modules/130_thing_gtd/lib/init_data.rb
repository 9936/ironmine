#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:TASK=================================
  map.function_group :task, {
      :en => {:name => "Tasks", :description => "Task"},
      :zh => {:name => "任务", :description => "任务"}
  }
  map.function_group :task, {
      :zone_code => "TASK",
      :controller => "gtd/tasks",
      :action => "index"}
  map.function_group :task, {
      :children => {
          :task => {
              :en => {:name => "Task", :description => "Task"},
              :zh => {:name => "任务", :description => "任务"},
              :default_flag => "Y",
              :login_flag => "N",
              :public_flag => "N",
               ##"edit_recurrence", "update_recurrence", "my_tasks_get_data", "my_tasks_index",
              "gtd/tasks" => ["create","update", "edit", "get_data", "index", "new","get_assigned_data", "show", "get_calendar_data"],
              "gtd/task_workbenches" => ["index"]
          }
      }
  }
  #=================================END:TASK=================================
end