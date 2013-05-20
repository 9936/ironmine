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

    #Task Workbenches
    match '/task_workbenches(/index)(.:format)' => "task_workbenches#index", :via => :get
    match '/task_workbenches/get_instance_data(.:format)' => "task_workbenches#get_instance_data", :via => :get

    #task_assigns
    match '/task_assigns/:sid(/index)(.:format)' => "task_assigns#index", :via => :get
    match '/task_assigns/:sid/:id/show(.:format)' => "task_assigns#show", :via => :get
    match '/task_assigns/:sid/new(.:format)' => "task_assigns#new", :via => :get
    match '/task_assigns/:sid/create(.:format)' => "task_assigns#create", :via => :post
    match '/task_assigns/:sid/:id/edit(.:format)' => "task_assigns#edit", :via => :get
    match '/task_assigns/:sid/:id(.:format)' => "task_assigns#update", :via => :put
    match '/task_assigns/:sid/get_data(.:format)' => "task_assigns#get_data"
    match '/task_assigns/:sid/:id/add_member(.:format)' => "task_assigns#add_member"
    match '/task_assigns/:sid/:id/get_to_people_data(.:format)' => "task_assigns#get_to_people_data"
    match '/task_assigns/:sid/:id/get_from_people_data(.:format)' => "task_assigns#get_from_people_data"
    match '/task_assigns/:sid/:id/delete_member(.:format)' => "task_assigns#delete_member"

  end
end