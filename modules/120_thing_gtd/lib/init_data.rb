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
              "gtd/tasks" => ["create", "edit", "edit_recurrence", "get_data", "get_top_data", "index", "my_tasks_get_data", "my_tasks_index", "new", "show", "update", "update_recurrence"]
          }
      }
  }
  #=================================END:TASK=================================
  #=================================START:SYSTEM TASK=================================


  map.menu :system_common_setting, {
      :children => {
          :system_task_setting => {
              :type => "menu",
              :entry => {
                  :sequence => 50,
                  :en => {:name => "Task Setting", :description => "Task Setting"},
                  :zh => {:name => "任务设置", :description => "任务设置"}
              }
          }
      }
  }

  map.menu :system_task_setting, {
      :en => {:name => "Task Setting", :description => "Task Setting"},
      :zh => {:name => "任务设置", :description => "任务设置"},
      :children => {
          :system_task_assign => {
              :type => "function",
              :entry => {
                  :sequence => 10,
                  :en => {:name => "Assign hierarchy", :description => "Assign hierarchy"},
                  :zh => {:name => "分派层次", :description => "分派层次"},
              }
          }
      }
  }
  map.function_group :system_task_assign, {
      :en => {:name => "Assign hierarchy", :description => "Assign hierarchy"},
      :zh => {:name => "分派层次", :description => "分派层次"},
      :system_flag => 'Y'
  }
  map.function_group :system_task_assign, {
          :zone_code => "HOME_PAGE",
          :controller => "gtd/task_assigns",
          :action => "index"
  }
  map.function_group :system_task_assign, {
      :children => {
          :system_incident_status => {
              :en => {:name => "Assign hierarchy", :description => "Assign hierarchy"},
              :zh => {:name => "分派层次", :description => "分派层次"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "gtd/task_assigns" => ["create", "edit", "get_data", "update", "index", "show","new", "add_member", "task_assign_from_people", "task_assign_to_people"]
          }
      }
  }

    #=================================END:SYSTEM TASK=================================

end