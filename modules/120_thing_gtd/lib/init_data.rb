#-*- coding: utf-8 -*-
Fwk::MenuAndFunctionManager.map do |map|
  #=================================START:TASK=================================
  map.function_group :task, {
      :en => {:name => "Tasks", :description => "Task"},
      :zh => {:name => "任务", :description => "任务"}
  }
  map.function_group :task, {
      :zone_code => "HOME_PAGE",
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
              "gtd/tasks" => ["create", "edit", "edit_recurrence", "get_data", "get_top_data", "index", "my_tasks_get_data", "my_tasks_index", "new", "show", "update", "update_recurrence"],
          }
      }
  }
  #=================================END:TASK=================================
end