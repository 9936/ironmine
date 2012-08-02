Ironmine::Application.routes.draw do



  scope  :module => "chm" do
    #change_statuses
    match '/change_statuses(/index)(.:format)' => "change_statuses#index", :via => :get
    match '/change_statuses/:id/edit(.:format)' => "change_statuses#edit", :via => :get
    match '/change_statuses/:id(.:format)' => "change_statuses#update", :via => :put
    match '/change_statuses/new(.:format)' => "change_statuses#new", :via => :get
    match '/change_statuses/create(.:format)' => "change_statuses#create", :via => :post
    match '/change_statuses/:id/show(.:format)' => "change_statuses#show", :via => :get
    match '/change_statuses/get_data(.:format)' => "change_statuses#get_data"
    match '/change_statuses/:id/multilingual_edit(.:format)' => "change_statuses#multilingual_edit", :via => :get
    match '/change_statuses/:id/multilingual_update(.:format)' => "change_statuses#multilingual_update", :via => :put


    #change_urgencies
    match '/change_urgencies(/index)(.:format)' => "change_urgencies#index", :via => :get
    match '/change_urgencies/:id/edit(.:format)' => "change_urgencies#edit", :via => :get
    match '/change_urgencies/:id(.:format)' => "change_urgencies#update", :via => :put
    match '/change_urgencies/new(.:format)' => "change_urgencies#new", :via => :get
    match '/change_urgencies/create(.:format)' => "change_urgencies#create", :via => :post
    match '/change_urgencies/:id/show(.:format)' => "change_urgencies#show", :via => :get
    match '/change_urgencies/get_data(.:format)' => "change_urgencies#get_data"
    match '/change_urgencies/:id/multilingual_edit(.:format)' => "change_urgencies#multilingual_edit", :via => :get
    match '/change_urgencies/:id/multilingual_update(.:format)' => "change_urgencies#multilingual_update", :via => :put

    #change_impacts
    match '/change_impacts(/index)(.:format)' => "change_impacts#index", :via => :get
    match '/change_impacts/:id/edit(.:format)' => "change_impacts#edit", :via => :get
    match '/change_impacts/:id(.:format)' => "change_impacts#update", :via => :put
    match '/change_impacts/new(.:format)' => "change_impacts#new", :via => :get
    match '/change_impacts/create(.:format)' => "change_impacts#create", :via => :post
    match '/change_impacts/:id/show(.:format)' => "change_impacts#show", :via => :get
    match '/change_impacts/get_data(.:format)' => "change_impacts#get_data"
    match '/change_impacts/:id/multilingual_edit(.:format)' => "change_impacts#multilingual_edit", :via => :get
    match '/change_impacts/:id/multilingual_update(.:format)' => "change_impacts#multilingual_update", :via => :put

    #change_priorities
    match '/change_priorities(/index)(.:format)' => "change_priorities#index", :via => :get
    match '/change_priorities/:id/edit(.:format)' => "change_priorities#edit", :via => :get
    match '/change_priorities/:id(.:format)' => "change_priorities#update", :via => :put
    match '/change_priorities/new(.:format)' => "change_priorities#new", :via => :get
    match '/change_priorities/create(.:format)' => "change_priorities#create", :via => :post
    match '/change_priorities/:id/show(.:format)' => "change_priorities#show", :via => :get
    match '/change_priorities/get_data(.:format)' => "change_priorities#get_data"
    match '/change_priorities/:id/multilingual_edit(.:format)' => "change_priorities#multilingual_edit", :via => :get
    match '/change_priorities/:id/multilingual_update(.:format)' => "change_priorities#multilingual_update", :via => :put

    #change_requests
    match '/change_requests(/index)(.:format)' => "change_requests#index", :via => :get
    match '/change_requests/:id/edit(.:format)' => "change_requests#edit", :via => :get
    match '/change_requests/:id(.:format)' => "change_requests#update", :via => :put
    match '/change_requests/new(.:format)' => "change_requests#new", :via => :get
    match '/change_requests/create(.:format)' => "change_requests#create", :via => :post
    match '/change_requests/:id/show(.:format)' => "change_requests#show", :via => :get
    match '/change_requests/get_data(.:format)' => "change_requests#get_data"
    match '/change_requests/:id/show_incident(.:format)' => "change_requests#show_incident", :via => :get
    match '/change_requests/:id/show_config(.:format)' => "change_requests#show_config", :via => :get
    match '/change_requests/:id/show_plan(.:format)' => "change_requests#show_plan", :via => :get
    match '/change_requests/:id/show_implement(.:format)' => "change_requests#show_implement", :via => :get
    match '/change_requests/:id/show_approve(.:format)' => "change_requests#show_approve", :via => :get
    match '/change_requests/:request_id/incident_new(.:format)' => "change_requests#incident_new", :via => :get
    match '/change_requests/:id/show_detail(.:format)' => "change_requests#show_detail", :via => :get

    #change journals
    match '/change_requests/:request_id/change_journals/create(.:format)' => "change_journals#create", :via => :post

    #change_plan_types
    match '/change_plan_types(/index)(.:format)' => "change_plan_types#index", :via => :get
    match '/change_plan_types/:id/edit(.:format)' => "change_plan_types#edit", :via => :get
    match '/change_plan_types/:id(.:format)' => "change_plan_types#update", :via => :put
    match '/change_plan_types/new(.:format)' => "change_plan_types#new", :via => :get
    match '/change_plan_types/create(.:format)' => "change_plan_types#create", :via => :post
    match '/change_plan_types/:id/show(.:format)' => "change_plan_types#show", :via => :get
    match '/change_plan_types/get_data(.:format)' => "change_plan_types#get_data"
    match '/change_plan_types/:id/multilingual_edit(.:format)' => "change_plan_types#multilingual_edit", :via => :get
    match '/change_plan_types/:id/multilingual_update(.:format)' => "change_plan_types#multilingual_update", :via => :put

    #change plans
    match '/change_plans/:change_request_id/change/:change_plan_type_id' => "change_plans#change", :via => :get
    match '/change_plans/create' => "change_plans#create", :via => :post
    match '/change_plans/:id/update' => "change_plans#update", :via => :put
    match '/change_plans/:change_request_id/refresh/:change_plan_type_id' => "change_plans#refresh", :via => :get

    #change_task_phases
    match '/change_task_phases(/index)(.:format)' => "change_task_phases#index", :via => :get
    match '/change_task_phases/:id/edit(.:format)' => "change_task_phases#edit", :via => :get
    match '/change_task_phases/:id(.:format)' => "change_task_phases#update", :via => :put
    match '/change_task_phases/new(.:format)' => "change_task_phases#new", :via => :get
    match '/change_task_phases/create(.:format)' => "change_task_phases#create", :via => :post
    match '/change_task_phases/:id/show(.:format)' => "change_task_phases#show", :via => :get
    match '/change_task_phases/get_data(.:format)' => "change_task_phases#get_data"
    match '/change_task_phases/:id/multilingual_edit(.:format)' => "change_task_phases#multilingual_edit", :via => :get
    match '/change_task_phases/:id/multilingual_update(.:format)' => "change_task_phases#multilingual_update", :via => :put

    #change_task_templates
    match '/change_task_templates(/index)(.:format)' => "change_task_templates#index", :via => :get
    match '/change_task_templates/:id/edit(.:format)' => "change_task_templates#edit", :via => :get
    match '/change_task_templates/:id(.:format)' => "change_task_templates#update", :via => :put
    match '/change_task_templates/new(.:format)' => "change_task_templates#new", :via => :get
    match '/change_task_templates/create(.:format)' => "change_task_templates#create", :via => :post
    match '/change_task_templates/:id/show(.:format)' => "change_task_templates#show", :via => :get
    match '/change_task_templates/:id/show_tasks(.:format)' => "change_task_templates#show_tasks", :via => :get
    match '/change_task_templates/get_data(.:format)' => "change_task_templates#get_data"
    match '/change_task_templates/:id/multilingual_edit(.:format)' => "change_task_templates#multilingual_edit", :via => :get
    match '/change_task_templates/:id/multilingual_update(.:format)' => "change_task_templates#multilingual_update", :via => :put

    #change_template_tasks
    match '/change_template_tasks/:id/edit(.:format)' => "change_template_tasks#edit", :via => :get
    match '/change_template_tasks/:id(.:format)' => "change_template_tasks#update", :via => :put
    match '/change_template_tasks/:source_id/new(.:format)' => "change_template_tasks#new", :via => :get
    match '/change_template_tasks/create(.:format)' => "change_template_tasks#create", :via => :post
    match '/change_template_tasks/:id/show(.:format)' => "change_template_tasks#show", :via => :get
    match '/change_template_tasks/:id/destroy(.:format)' => "change_template_tasks#destroy", :via => :delete

    #change_template_tasks
    match '/change_tasks/:id/edit(.:format)' => "change_tasks#edit", :via => :get
    match '/change_tasks/:id(.:format)' => "change_tasks#update", :via => :put
    match '/change_tasks/:source_id/new(.:format)' => "change_tasks#new", :via => :get
    match '/change_tasks/create(.:format)' => "change_tasks#create", :via => :post
    match '/change_tasks/:id/show(.:format)' => "change_tasks#show", :via => :get
    match '/change_tasks/:id/destroy(.:format)' => "change_tasks#destroy", :via => :delete
    match '/change_tasks/:source_id/template_new(.:format)' => "change_tasks#template_new", :via => :get
    match '/change_tasks/template_create(.:format)' => "change_tasks#template_create", :via => :post

    #change incident relations
    match '/change_incident_relations/create(.:format)' => "change_incident_relations#create", :via => :post
    match '/change_incident_relations/:change_request_id/:incident_request_id/destroy(.:format)' => "change_incident_relations#destroy", :via => :delete
    match '/change_incident_relations/:change_request_id/incident_requests(.:format)' => "change_incident_relations#incident_requests", :via => :get

    #change incident relations
    match '/change_config_relations/create(.:format)' => "change_config_relations#create", :via => :post
    match '/change_config_relations/:id/destroy(.:format)' => "change_config_relations#destroy", :via => :delete

    #advisory_boards
    match '/advisory_boards(/index)(.:format)' => "advisory_boards#index", :via => :get
    match '/advisory_boards/:id/edit(.:format)' => "advisory_boards#edit", :via => :get
    match '/advisory_boards/:id(.:format)' => "advisory_boards#update", :via => :put
    match '/advisory_boards/new(.:format)' => "advisory_boards#new", :via => :get
    match '/advisory_boards/create(.:format)' => "advisory_boards#create", :via => :post
    match '/advisory_boards/:id/show(.:format)' => "advisory_boards#show", :via => :get
    match '/advisory_boards/:id/show_tasks(.:format)' => "advisory_boards#show_tasks", :via => :get
    match '/advisory_boards/get_data(.:format)' => "advisory_boards#get_data"

    match '/advisory_board_members/:advisory_board_id/new(.:format)' => "advisory_board_members#new", :via => :get
    match '/advisory_board_members/:advisory_board_id/create(.:format)' => "advisory_board_members#create", :via => :post
    match '/advisory_board_members/:advisory_board_id/get_data(.:format)' => "advisory_board_members#get_data"
    match '/advisory_board_members/:id/destroy(.:format)' => "advisory_board_members#destroy", :via => :delete

    match '/change_approvals/:change_request_id/new(.:format)' => "change_approvals#new", :via => :get
    match '/change_approvals/:change_request_id/create(.:format)' => "change_approvals#create", :via => :post
    match '/change_approvals/:id/destroy(.:format)' => "change_approvals#destroy", :via => :delete
    match '/change_approvals/get_available_member(.:format)' => "change_approvals#get_available_member", :via => :get
    match '/change_approvals/:change_request_id/submit(.:format)' => "change_approvals#submit", :via => :get
    match '/change_approvals/:id/approve(.:format)' => "change_approvals#approve", :via => :get
    match '/change_approvals/:id/decide(.:format)' => "change_approvals#decide", :via => [:post,:put]

  end
end
