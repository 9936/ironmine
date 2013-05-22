Rails.application.routes.draw do
  scope :module => "gtd" do
    #tasks
    match '/tasks(/index)(.:format)' => "tasks#index", :via => :get
    match '/tasks/new(.:format)' => "tasks#new", :via => :get
    match '/tasks/create(.:format)' => "tasks#create", :via => :post
    match '/tasks/:id/edit(.:format)' => "tasks#edit", :via => :get
    match '/tasks/:id(.:format)' => "tasks#update", :via => :put
    match '/tasks/get_data(.:format)' => "tasks#get_data"
    match '/tasks/get_calendar_data(.:format)' => "tasks#get_calendar_data"
    match '/tasks/:id/show(.:format)' => "tasks#show", :via => :get
    #match '/tasks/get_assigned_data(.:format)' => "tasks#get_assigned_data", :via => :get
    #match '/tasks/:id/edit_recurrence(.:format)' => "tasks#edit_recurrence", :via => :get
    #match '/tasks/:id/update_recurrence(.:format)' => "tasks#update_recurrence", :via => :put
    #match '/tasks/my_tasks_index(.:format)' => "tasks#my_tasks_index", :via => :get
    #match '/tasks/my_tasks_get_data(.:format)' => "tasks#my_tasks_get_data"
    #match '/tasks/portlet(.:format)' => "tasks#portlet", :via => :get

    #task_orkbenches
    match '/task_workbenches(/index)(.:format)' => "task_workbenches#index", :via => :get
    match '/task_workbenches/today(.:format)' => "task_workbenches#today", :via => :get
    match '/task_workbenches/:id/edit(.:format)' => "task_workbenches#edit", :via => :get
    match '/task_workbenches/:id/done(.:format)' => "task_workbenches#done", :via => :get
    match '/task_workbenches/:id/update_done(.:format)' => "task_workbenches#update_done", :via => :put
    match '/task_workbenches/:id(.:format)' => "task_workbenches#update", :via => :put
    match '/task_workbenches/:id/show(.:format)' => "task_workbenches#show", :via => :get
    match '/task_workbenches/get_instance_data(.:format)' => "task_workbenches#get_instance_data", :via => :get
    match '/task_workbenches/today_instance_data(.:format)' => "task_workbenches#today_instance_data", :via => :get

    #notify programs
    match '/notify_programs(/index)(.:format)' => "notify_programs#index", :via => :get
    match '/notify_programs/new(.:format)' => "notify_programs#new", :via => :get
    match '/notify_programs/create(.:format)' => "notify_programs#create", :via => :post
    match '/notify_programs/:id/edit(.:format)' => "notify_programs#edit", :via => :get
    match '/notify_programs/:id(.:format)' => "notify_programs#update", :via => :put
    match '/notify_programs/:id/show(.:format)' => "notify_programs#show", :via => :get
    match '/notify_programs/get_data(.:format)' => "notify_programs#get_data"
    match '/notify_programs/:id/multilingual_edit(.:format)' => "notify_programs#multilingual_edit", :via => :get
    match '/notify_programs/:id/multilingual_update(.:format)' => "notify_programs#multilingual_update", :via => :put

  end
end