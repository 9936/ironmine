Rails.application.routes.draw do
  scope :module => "isp" do
  #namespace :isp do
    #programs
    match '/programs(/index)(.:format)' => "programs#index", :via => :get
    match '/programs/get_data(.:format)' => "programs#get_data"
    match '/programs/:id/edit(.:format)' => "programs#edit", :via => :get
    match '/programs/:id(.:format)' => "programs#update", :via => :put
    match '/programs/new(.:format)' => "programs#new", :via => :get
    match '/programs/:id(.:format)' => "programs#show", :via => :get
    match '/programs/create(.:format)' => "programs#create", :via => :post
    match '/programs/:id/multilingual_edit(.:format)' => "programs#multilingual_edit", :via => :get
    match '/programs/:id/multilingual_update(.:format)' => "programs#multilingual_update", :via => :put
    match '/programs/:id/new_execute(.:format)' => "programs#new_execute", :via => :get
    match '/programs/:id/create_execute(.:format)' => "programs#create_execute", :via => :put
    match '/programs/:id/new_trigger(.:format)' => "programs#new_trigger", :via => :get
    match '/programs/:id/create_trigger(.:format)' => "programs#create_trigger", :via => :put


    #connections
    match '/programs/:program_id/connections/get_data(.:format)' => "connections#get_data"
    match '/programs/:program_id/connections/:id/edit(.:format)' => "connections#edit", :via => :get
    match '/programs/:program_id/connections/:id(.:format)' => "connections#update", :via => :put
    match '/programs/:program_id/connections/new(.:format)' => "connections#new", :via => :get
    match '/programs/:program_id/connections/:id(.:format)' => "connections#show", :via => :get
    match '/programs/:program_id/connections/:id/destroy(.:format)' => "connections#destroy", :via => :delete
    match '/programs/:program_id/connections/create(.:format)' => "connections#create", :via => :post
    match '/programs/:program_id/connections/:id/add_items(.:format)' => "connections#add_items", :via => :get
    match '/programs/:program_id/connections/:id/save_items(.:format)' => "connections#save_items", :via => :post
    match '/programs/:program_id/connections/:id/get_items_data(.:format)' => "connections#get_items_data", :via => :get
    match '/programs/:program_id/connections/:connection_item_id/remove_item(.:format)' => "connections#remove_item", :via => :delete

    #check_templates
    match '/programs/:program_id/check_templates/get_data(.:format)' => "check_templates#get_data"
    match '/programs/:program_id/check_templates/:id/edit(.:format)' => "check_templates#edit", :via => :get
    match '/programs/:program_id/check_templates/:id(.:format)' => "check_templates#update", :via => :put
    match '/programs/:program_id/check_templates/new(.:format)' => "check_templates#new", :via => :get
    match '/programs/:program_id/check_templates/:id(.:format)' => "check_templates#show", :via => :get
    match '/programs/:program_id/check_templates/:id/destroy(.:format)' => "check_templates#destroy", :via => :delete
    match '/programs/:program_id/check_templates/create(.:format)' => "check_templates#create", :via => :post


    #check_items
    match '/check_items(/index)(.:format)' => "check_items#index", :via => :get
    match '/check_items/get_data(.:format)' => "check_items#get_data"
    match '/check_items/:id/edit(.:format)' => "check_items#edit", :via => :get
    match '/check_items/:id(.:format)' => "check_items#update", :via => :put
    match '/check_items/new(.:format)' => "check_items#new", :via => :get
    match '/check_items/:id(.:format)' => "check_items#show", :via => :get
    match '/check_items/:id/destroy(.:format)' => "check_items#destroy", :via => :delete
    match '/check_items/create(.:format)' => "check_items#create", :via => :post

    #check_parameters
    match '/check_items/:check_item_id/check_parameters/get_data(.:format)' => "check_parameters#get_data"
    match '/check_items/:check_item_id/check_parameters/:id/edit(.:format)' => "check_parameters#edit", :via => :get
    match '/check_items/:check_item_id/check_parameters/:id(.:format)' => "check_parameters#update", :via => :put
    match '/check_items/:check_item_id/check_parameters/new(.:format)' => "check_parameters#new", :via => :get
    match '/check_items/:check_item_id/check_parameters/:id(.:format)' => "check_parameters#show", :via => :get
    match '/check_items/:check_item_id/check_parameters/:id/destroy(.:format)' => "check_parameters#destroy", :via => :delete
    match '/check_items/:check_item_id/check_parameters/create(.:format)' => "check_parameters#create", :via => :post

    #alert_filters
    match '/check_items/:check_item_id/alert_filters/get_data(.:format)' => "alert_filters#get_data"
    match '/check_items/:check_item_id/alert_filters/get_operator_data(.:format)' => "alert_filters#get_operator_data"
    match '/check_items/:check_item_id/alert_filters/:id/edit(.:format)' => "alert_filters#edit", :via => :get
    match '/check_items/:check_item_id/alert_filters/:id(.:format)' => "alert_filters#update", :via => :put
    match '/check_items/:check_item_id/alert_filters/new(.:format)' => "alert_filters#new", :via => :get
    match '/check_items/:check_item_id/alert_filters/:id(.:format)' => "alert_filters#show", :via => :get
    match '/check_items/:check_item_id/alert_filters/:id/destroy(.:format)' => "alert_filters#destroy", :via => :delete
    match '/check_items/:check_item_id/alert_filters/create(.:format)' => "alert_filters#create", :via => :post



  end


end