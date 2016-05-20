Ironmine::Application.routes.draw do
  scope :module => "icm" do
    match '/incident_requests/get_attend_incident(.:format)' => "incident_requests#get_attend_incident"

    match 'incident_journals/:request_id/:sid/edit_additional_info(.:format)' => "incident_journals#edit_additional_info", :via => :get
    match 'incident_journals/:request_id/:sid/update_additional_info(.:format)' => "incident_journals#update_additional_info", :via => :put

    match 'incident_journals/:request_id/:sid/edit_workload(.:format)' => "incident_journals#edit_workload", :via => :get
    match 'incident_journals/:request_id/:sid/update_workload(.:format)' => "incident_journals#update_workload", :via => :put
  end

  scope :module => "irm" do
    match '/reports/:id/generate_xls(.:format)' => "reports#generate_xls", :via => :get
    match '/reports/:id/download_xls(.:format)' => "reports#download_xls", :via => :get
  end

  scope :module => "yan" do
    match '/parent_people/:id/new_from_person(.:format)' => "parent_people#new_from_person"
    match '/parent_people/:id/delete_from_parent(.:format)' => "parent_people#delete_from_parent"
    match '/parent_people/:id/get_owned_parents_data(.:format)' => "parent_people#get_owned_parents_data"
    match '/parent_people/:id/get_ava_parents_data(.:format)' => "parent_people#get_ava_parents_data"
    match '/parent_people/:id/create_from_person(.:format)' => "parent_people#create_from_person"

    match '/workload_authorities(/index)(.:format)' => "workload_authorities#index", :via => :get
    match '/workload_authorities/add_workload_authority(.:format)' => "workload_authorities#add_workload_authority"

    match '/workload_register(/index)(.:format)' => "workload_register#index", :via => :get
    match '/workload_register/create_workload(.:format)' => "workload_register#create_workload"
    match '/workload_register/update_workload(.:format)' => "workload_register#update_workload"
    match '/workload_register/update_workload_by_resize(.:format)' => "workload_register#update_workload_by_resize"
    match '/workload_register/update_workload_by_drop(.:format)' => "workload_register#update_workload_by_drop"
    match '/workload_register/delete_workload(.:format)' => "workload_register#delete_workload"
    match '/workload_register/get_week_workload(.:format)' => "workload_register#get_week_workload"
  end

end