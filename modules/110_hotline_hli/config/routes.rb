Ironmine::Application.routes.draw do
 scope :module => "icm" do
   match '/incident_requests/:id/cancel_request(.:format)' => "incident_requests#cancel_request"
   match '/incident_requests/:id/enable_request(.:format)' => "incident_requests#enable_request"
   match '/incident_requests/:request_id/journals/edit_workload(.:format)' => "incident_journals#edit_workload", :via => :get
   match '/incident_requests/:request_id/journals/update_workload(.:format)' => "incident_journals#update_workload", :via => :put
   match '/incident_requests/:request_id/journals/:journal_id/remove_journal(.:format)' => "incident_journals#remove_journal", :via => :get
   match '/incident_requests/:request_id/journals/get_incident_history_data(.:format)' => "incident_journals#get_incident_history_data", :via => :get
 end

 scope :module => "irm" do
   match '/reports/new_template(.:format)' => "reports#new_template", :via => [:get,:post]
   match '/reports/show_template(.:format)' => "reports#show_template", :via => :get
   match '/reports/create_template(.:format)' => "reports#create_template", :via => :post
   match '/reports/:id/edit_template(.:format)' => "reports#edit_template", :via => [:get,:post,:put]
   match '/reports/:id/update_template(.:format)' => "reports#update_template", :via => :put

    #hotline project
    match '/projects/new(.:format)' => "projects#new", :via => :get
    match '/projects/create(.:format)' => "projects#create", :via => :post
    match '/projects/add_person(.:format)' => "projects#add_person", :via => :get
    match '/projects/create_person(.:format)' => "projects#create_person", :via => :post
    match '/projects/add_supporter(.:format)' => "projects#add_supporter", :via => :get
    match '/projects/create_supporter(.:format)' => "projects#create_supporter", :via => :post
    match '/projects/edit(.:format)' => "projects#edit", :via => :get
    match '/projects/update(.:format)' => "projects#update", :via => :post
    match '/projects(/index)(.:format)' => "projects#index", :via => :get
    match '/projects/get_data(.:format)' => "projects#get_data", :via => :get
    match '/projects/:id/show(.:format)' => "projects#show", :via => :get
    match '/projects/:project_code/get_support_person_list_data(.:format)' => "projects#get_support_person_list_data", :via => :get
    match '/projects/:project_code/get_customer_list_data(.:format)' => "projects#get_customer_list_data", :via => :get
    match '/projects/:person_id/:project_code/remove_project_supporter(.:format)' => "projects#remove_project_supporter"
    match '/projects/:person_id/:project_code/remove_project_customer(.:format)' => "projects#remove_project_customer"
    match '/projects/:project_code/add_supporter_to_project(.:format)' => "projects#add_supporter_to_project"
    match '/projects/:project_code/add_customer_to_project(.:format)' => "projects#add_customer_to_project"
    match '/projects/:project_code/add_supporters(.:format)' => "projects#add_supporters"
    match '/projects/:project_code/add_customers(.:format)' => "projects#add_customers"
    match '/projects/:project_code/get_available_project_supporter_data(.:format)' => "projects#get_available_project_supporter_data"
    match '/projects/:project_code/get_available_project_customer_data(.:format)' => "projects#get_available_project_customer_data"
 end
end
