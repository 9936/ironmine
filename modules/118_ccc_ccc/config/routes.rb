Ironmine::Application.routes.draw do
  scope :module => "ccc" do
    match '/statusCons(/index)(.:format)' => "statusCons#index", :via => :get
    match '/statusCons/new(.:format)' => "statusCons#new", :via => :get
    match '/statusCons/create(.:format)' => "statusCons#create", :via => :post
    match '/statusCons/:id/edit(.:format)' => "statusCons#edit", :via => :get
    match '/statusCons/:id(.:format)' => "statusCons#update", :via => :put
    match '/statusCons/get_data(.:format)' => "statusCons#get_data"

    match '/projectTypes(/index)(.:format)' => "projectTypes#index", :via => :get
    match '/projectTypes/get_data(.:format)' => "projectTypes#get_data"
    match '/projectTypes/:id/edit(.:format)' => "projectTypes#edit", :via => :get
    match '/projectTypes/:id(.:format)' => "projectTypes#update", :via => :put
    match '/projectTypes/new(.:format)' => "projectTypes#new", :via => :get
    match '/projectTypes/create(.:format)' => "projectTypes#create", :via => :post
    match '/projectTypes/:id/multilingual_edit(.:format)' => "projectTypes#multilingual_edit", :via => :get
    match '/projectTypes/:id/multilingual_update(.:format)' => "projectTypes#multilingual_update", :via => :put
    match '/projectTypes/:id/show(.:format)' => "projectTypes#show", :via => :get

    match '/priceTypes(/index)(.:format)' => "priceTypes#index", :via => :get
    match '/priceTypes/get_data(.:format)' => "priceTypes#get_data"
    match '/priceTypes/:id/edit(.:format)' => "priceTypes#edit", :via => :get
    match '/priceTypes/:id(.:format)' => "priceTypes#update", :via => :put
    match '/priceTypes/new(.:format)' => "priceTypes#new", :via => :get
    match '/priceTypes/create(.:format)' => "priceTypes#create", :via => :post
    match '/priceTypes/:id/multilingual_edit(.:format)' => "priceTypes#multilingual_edit", :via => :get
    match '/priceTypes/:id/multilingual_update(.:format)' => "priceTypes#multilingual_update", :via => :put
    match '/priceTypes/:id/show(.:format)' => "priceTypes#show", :via => :get

    match '/sexes(/index)(.:format)' => "sexes#index", :via => :get
    match '/sexes/get_data(.:format)' => "sexes#get_data"
    match '/sexes/:id/edit(.:format)' => "sexes#edit", :via => :get
    match '/sexes/:id(.:format)' => "sexes#update", :via => :put
    match '/sexes/new(.:format)' => "sexes#new", :via => :get
    match '/sexes/create(.:format)' => "sexes#create", :via => :post
    match '/sexes/:id/multilingual_edit(.:format)' => "sexes#multilingual_edit", :via => :get
    match '/sexes/:id/multilingual_update(.:format)' => "sexes#multilingual_update", :via => :put
    match '/sexes/:id/show(.:format)' => "sexes#show", :via => :get

    match '/customerStatuses(/index)(.:format)' => "customerStatuses#index", :via => :get
    match '/customerStatuses/get_data(.:format)' => "customerStatuses#get_data"
    match '/customerStatuses/:id/edit(.:format)' => "customerStatuses#edit", :via => :get
    match '/customerStatuses/:id(.:format)' => "customerStatuses#update", :via => :put
    match '/customerStatuses/new(.:format)' => "customerStatuses#new", :via => :get
    match '/customerStatuses/create(.:format)' => "customerStatuses#create", :via => :post
    match '/customerStatuses/:id/multilingual_edit(.:format)' => "customerStatuses#multilingual_edit", :via => :get
    match '/customerStatuses/:id/multilingual_update(.:format)' => "customerStatuses#multilingual_update", :via => :put
    match '/customerStatuses/:id/show(.:format)' => "customerStatuses#show", :via => :get

    match '/consultantTypes(/index)(.:format)' => "consultantTypes#index", :via => :get
    match '/consultantTypes/get_data(.:format)' => "consultantTypes#get_data"
    match '/consultantTypes/:id/edit(.:format)' => "consultantTypes#edit", :via => :get
    match '/consultantTypes/:id(.:format)' => "consultantTypes#update", :via => :put
    match '/consultantTypes/new(.:format)' => "consultantTypes#new", :via => :get
    match '/consultantTypes/create(.:format)' => "consultantTypes#create", :via => :post
    match '/consultantTypes/:id/multilingual_edit(.:format)' => "consultantTypes#multilingual_edit", :via => :get
    match '/consultantTypes/:id/multilingual_update(.:format)' => "consultantTypes#multilingual_update", :via => :put
    match '/consultantTypes/:id/show(.:format)' => "consultantTypes#show", :via => :get

    match '/consultantModules(/index)(.:format)' => "consultantModules#index", :via => :get
    match '/consultantModules/get_data(.:format)' => "consultantModules#get_data"
    match '/consultantModules/:id/edit(.:format)' => "consultantModules#edit", :via => :get
    match '/consultantModules/:id(.:format)' => "consultantModules#update", :via => :put
    match '/consultantModules/new(.:format)' => "consultantModules#new", :via => :get
    match '/consultantModules/create(.:format)' => "consultantModules#create", :via => :post
    match '/consultantModules/:id/multilingual_edit(.:format)' => "consultantModules#multilingual_edit", :via => :get
    match '/consultantModules/:id/multilingual_update(.:format)' => "consultantModules#multilingual_update", :via => :put
    match '/consultantModules/:id/show(.:format)' => "consultantModules#show", :via => :get

    match '/consultantStatuses(/index)(.:format)' => "consultantStatuses#index", :via => :get
    match '/consultantStatuses/get_data(.:format)' => "consultantStatuses#get_data"
    match '/consultantStatuses/:id/edit(.:format)' => "consultantStatuses#edit", :via => :get
    match '/consultantStatuses/:id(.:format)' => "consultantStatuses#update", :via => :put
    match '/consultantStatuses/new(.:format)' => "consultantStatuses#new", :via => :get
    match '/consultantStatuses/create(.:format)' => "consultantStatuses#create", :via => :post
    match '/consultantStatuses/:id/multilingual_edit(.:format)' => "consultantStatuses#multilingual_edit", :via => :get
    match '/consultantStatuses/:id/multilingual_update(.:format)' => "consultantStatuses#multilingual_update", :via => :put
    match '/consultantStatuses/:id/show(.:format)' => "consultantStatuses#show", :via => :get

    match '/consultantLevels(/index)(.:format)' => "consultantLevels#index", :via => :get
    match '/consultantLevels/get_data(.:format)' => "consultantLevels#get_data"
    match '/consultantLevels/:id/edit(.:format)' => "consultantLevels#edit", :via => :get
    match '/consultantLevels/:id(.:format)' => "consultantLevels#update", :via => :put
    match '/consultantLevels/new(.:format)' => "consultantLevels#new", :via => :get
    match '/consultantLevels/create(.:format)' => "consultantLevels#create", :via => :post
    match '/consultantLevels/:id/multilingual_edit(.:format)' => "consultantLevels#multilingual_edit", :via => :get
    match '/consultantLevels/:id/multilingual_update(.:format)' => "consultantLevels#multilingual_update", :via => :put
    match '/consultantLevels/:id/show(.:format)' => "consultantLevels#show", :via => :get

    match '/industries(/index)(.:format)' => "industries#index", :via => :get
    match '/industries/get_data(.:format)' => "industries#get_data"
    match '/industries/:id/edit(.:format)' => "industries#edit", :via => :get
    match '/industries/:id(.:format)' => "industries#update", :via => :put
    match '/industries/new(.:format)' => "industries#new", :via => :get
    match '/industries/create(.:format)' => "industries#create", :via => :post
    match '/industries/:id/multilingual_edit(.:format)' => "industries#multilingual_edit", :via => :get
    match '/industries/:id/multilingual_update(.:format)' => "industries#multilingual_update", :via => :put
    match '/industries/:id/show(.:format)' => "industries#show", :via => :get


    match '/connTypes(/index)(.:format)' => "connTypes#index", :via => :get
    match '/connTypes/get_data(.:format)' => "connTypes#get_data"
    match '/connTypes/:id/edit(.:format)' => "connTypes#edit", :via => :get
    match '/connTypes/:id(.:format)' => "connTypes#update", :via => :put
    match '/connTypes/new(.:format)' => "connTypes#new", :via => :get
    match '/connTypes/create(.:format)' => "connTypes#create", :via => :post
    match '/connTypes/:id/multilingual_edit(.:format)' => "connTypes#multilingual_edit", :via => :get
    match '/connTypes/:id/multilingual_update(.:format)' => "connTypes#multilingual_update", :via => :put
    match '/connTypes/:id/show(.:format)' => "connTypes#show", :via => :get

  end

 scope :module => "icm" do
   match '/incident_journals/register_workload(.:format)' => "incident_journals#register_workload"
   match '/incident_journals/grade_of_satisfy(.:format)' => "incident_journals#grade_of_satisfy"
   match '/incident_requests/delete_user_history(.:format)' => "incident_requests#delete_user_history"
   match '/incident_requests/get_user_histories(.:format)' => "incident_requests#get_user_histories"
   match '/incident_requests/get_external_systems_t(.:format)' => "incident_requests#get_external_systems_t"
   match '/incident_requests/:request_id/:sid/journals/update_people_date(.:format)' => "incident_journals#update_people_date", :via => :put
   match '/incident_requests/:source_id/:sid/add_entry_header_relation(.:format)' => "incident_requests#add_entry_header_relation", :via => :post
   match '/incident_requests/:source_id/:target_id/remove_entry_header_relation(.:format)' => "incident_requests#remove_entry_header_relation"

   match '/incident_requests/:id/cancel_request(.:format)' => "incident_requests#cancel_request"
   match '/incident_requests/:id/enable_request(.:format)' => "incident_requests#enable_request"
   match '/incident_requests/:request_id/journals/edit_workload(.:format)' => "incident_journals#edit_workload", :via => :get
   match '/incident_requests/:request_id/journals/update_workload(.:format)' => "incident_journals#update_workload", :via => :put
   match '/incident_requests/:request_id/journals/:journal_id/remove_journal(.:format)' => "incident_journals#remove_journal", :via => :get
   match '/incident_requests/:request_id/journals/get_incident_history_data(.:format)' => "incident_journals#get_incident_history_data", :via => :get
   match '/incident_requests/:request_id/journals/get_incident_listen_data(.:format)' => "incident_journals#get_incident_listen_data", :via => :get
 end

 scope :module => "irm" do
   match '/bulletins/get_data_limit(.:format)' => "bulletins#get_data_limit"

   match '/home/kinds_of_count(.:format)' => "home#kinds_of_count"

   match '/people/get_people_list(.:format)' => "people#get_people_list"
   match '/people/get_lov_data(.:format)' => "people#get_lov_data"
   match '/people/get_customer_no(.:format)' => "people#get_customer_no"
   match '/people/get_project_manager(.:format)' => "people#get_project_manager"

   match '/organizations/get_organization_no(.:format)' => "organizations#get_organization_no"

   match '/reports/newsemplate(.:format)' => "reports#newsemplate", :via => [:get,:post]
   match '/reports/showsemplate(.:format)' => "reports#showsemplate", :via => :get
   match '/reports/createsemplate(.:format)' => "reports#createsemplate", :via => :post
   match '/reports/:id/editsemplate(.:format)' => "reports#editsemplate", :via => [:get,:post,:put]
   match '/reports/:id/updatesemplate(.:format)' => "reports#updatesemplate", :via => :put

    #hotline project
    match '/projects/new(.:format)' => "projects#new", :via => :get
    match '/projects/create(.:format)' => "projects#create", :via => :post
    match '/projects/add_person(.:format)' => "projects#add_person", :via => :get
    match '/projects/create_person(.:format)' => "projects#create_person", :via => :post
    match '/projects/addSupporter(.:format)' => "projects#addSupporter", :via => :get
    match '/projects/createSupporter(.:format)' => "projects#createSupporter", :via => :post
    match '/projects/edit(.:format)' => "projects#edit", :via => :get
    match '/projects/update(.:format)' => "projects#update", :via => :post
    match '/projects(/index)(.:format)' => "projects#index", :via => :get
    match '/projects/get_data(.:format)' => "projects#get_data", :via => :get
    match '/projects/:id/show(.:format)' => "projects#show", :via => :get
    match '/projects/:project_code/getSupport_personList_data(.:format)' => "projects#getSupport_personList_data", :via => :get
    match '/projects/:project_code/get_customerList_data(.:format)' => "projects#get_customerList_data", :via => :get
    match '/projects/:person_id/:project_code/remove_projectSupporter(.:format)' => "projects#remove_projectSupporter"
    match '/projects/:person_id/:project_code/remove_project_customer(.:format)' => "projects#remove_project_customer"
    match '/projects/:project_code/addSupporterso_project(.:format)' => "projects#addSupporterso_project"
    match '/projects/:project_code/add_customerso_project(.:format)' => "projects#add_customerso_project"
    match '/projects/:project_code/addSupporters(.:format)' => "projects#addSupporters"
    match '/projects/:project_code/add_customers(.:format)' => "projects#add_customers"
    match '/projects/:project_code/get_available_projectSupporter_data(.:format)' => "projects#get_available_projectSupporter_data"
    match '/projects/:project_code/get_available_project_customer_data(.:format)' => "projects#get_available_project_customer_data"
 end

 #service catalog and service level agreement(slm)
 scope :module => "slm" do
   #calendars
   match '/calendars/:sid(/index)(.:format)' => "calendars#index", :via => :get
   match '/calendars/:sid/get_data(.:format)' => "calendars#get_data"
   match '/calendars/:sid/:id/edit(.:format)' => "calendars#edit", :via => :get
   match '/calendars/:sid/:id/synch(.:format)' => "calendars#synch", :via => :get
   match '/calendars/:sid/:id(.:format)' => "calendars#update", :via => :put
   match '/calendars/:sid/new(.:format)' => "calendars#new", :via => :get
   match '/calendars/:sid/:id(.:format)' => "calendars#show", :via => :get
   match '/calendars/:sid/:id/schedule_events(.:format)' => "calendars#schedule_events", :via => :get
   match '/calendars/:sid/create(.:format)' => "calendars#create", :via => :post
   match '/calendars/:sid/:id/multilingual_edit(.:format)' => "calendars#multilingual_edit", :via => :get
   match '/calendars/:sid/:id/multilingual_update(.:format)' => "calendars#multilingual_update", :via => :put
 end
end
