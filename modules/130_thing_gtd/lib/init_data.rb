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
              "gtd/tasks" => ["create","update", "edit", "get_data", "index", "new", "show", "get_calendar_data"]
          },
          :task_personal => {
              :en => {:name => "Personal Task", :description => "Personal Task"},
              :zh => {:name => "个人日常保障工作", :description => "个人日常保障工作"},
              :default_flag => "Y",
              :login_flag => "N",
              :public_flag => "N",
              "gtd/task_workbenches" => ["edit", "update","today","today_instance_data","done", "update_done", "show"]
          },
          :task_admin => {
              :en => {:name => "Task Monitor", :description => "Task Monitor"},
              :zh => {:name => "日常保障工作监控", :description => "日常保障工作监控"},
              :default_flag => "N",
              :login_flag => "N",
              :public_flag => "N",
              "gtd/task_workbenches" => ["index","get_instance_data", "edit", "update"]
          }
      }
  }
  #=================================END:TASK=================================

  #=================================START:NOTIFY PROGRAM=================================
  map.function_group :notify_program, {
      :en => {:name => "Notify Program", :description => "Notify Program"},
      :zh => {:name => "工作管理方案", :description => "工作管理方案"}
  }
  map.function_group :notify_program, {
      :zone_code => "TASK",
      :controller => "gtd/notify_programs",
      :action => "index"}
  map.function_group :notify_program, {
      :children => {
          :notify_program => {
              :en => {:name => "Notify Program", :description => "Notify Program"},
              :zh => {:name => "工作管理方案", :description => "工作管理方案"},
              :default_flag => "Y",
              :login_flag => "N",
              :public_flag => "N",
              "gtd/notify_programs" => ["create","update", "edit", "get_data", "index", "new", "show","multilingual_edit","multilingual_update"]
          }
      }
  }
  #=================================END:NOTIFY PROGRAM=================================

end