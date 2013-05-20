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
    match '/task_workbenches/:id/edit(.:format)' => "task_workbenches#edit", :via => :get
    match '/task_workbenches/:id(.:format)' => "task_workbenches#update", :via => :put
    match '/task_workbenches/get_instance_data(.:format)' => "task_workbenches#get_instance_data", :via => :get

  end
end