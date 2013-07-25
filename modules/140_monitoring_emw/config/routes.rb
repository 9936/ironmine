Rails.application.routes.draw do
  scope :module => "emw" do
    #Ebs_modules
    match '/ebs_modules(/index)(.:format)' => "ebs_modules#index", :via => :get
    match '/ebs_modules/get_data(.:format)' => "ebs_modules#get_data"
    match '/ebs_modules/:id/edit(.:format)' => "ebs_modules#edit", :via => :get
    match '/ebs_modules/:id(.:format)' => "ebs_modules#update", :via => :put
    match '/ebs_modules/new(.:format)' => "ebs_modules#new", :via => :get
    match '/ebs_modules/:id(.:format)' => "ebs_modules#show", :via => :get
    match '/ebs_modules/create(.:format)' => "ebs_modules#create", :via => :post

    #Interface
    match '/interfaces(/index)(.:format)' => "interfaces#index", :via => :get
    match '/interfaces/get_data(.:format)' => "interfaces#get_data"
    match '/interfaces/:id/edit(.:format)' => "interfaces#edit", :via => :get
    match '/interfaces/:id(.:format)' => "interfaces#update", :via => :put
    match '/interfaces/new(.:format)' => "interfaces#new", :via => :get
    match '/interfaces/:id(.:format)' => "interfaces#show", :via => :get
    match '/interfaces/create(.:format)' => "interfaces#create", :via => :post

    #Interface_table
    match '/interfaces/:interface_id/tables/get_data(.:format)' => "interface_tables#get_data"
    match '/interfaces/:interface_id/tables/:id/edit(.:format)' => "interface_tables#edit", :via => :get
    match '/interfaces/:interface_id/tables/:id(.:format)' => "interface_tables#update", :via => :put
    match '/interfaces/:interface_id/tables/new(.:format)' => "interface_tables#new", :via => :get
    match '/interfaces/:interface_id/tables/import(.:format)' => "interface_tables#import", :via => [:get, :post]
    match '/interfaces/:interface_id/tables/:id/(.:format)' => "interface_tables#show", :via => :get
    match '/interfaces/:interface_id/tables/create(.:format)' => "interface_tables#create", :via => :post

    #Interface_column
    match '/tables/:table_id/columns/:id/edit(.:format)' => "interface_columns#edit", :via => :get
    match '/tables/:table_id/columns/:id(.:format)' => "interface_columns#update", :via => :put
    match '/tables/:table_id/columns/new(.:format)' => "interface_columns#new", :via => :get
    match '/tables/:table_id/columns/:id/(.:format)' => "interface_columns#show", :via => :get
    match '/tables/:table_id/columns/create(.:format)' => "interface_columns#create", :via => :post
    match '/tables/:table_id/columns/:id/destroy(.:format)' => "interface_columns#destroy", :via => :delete

    #Error_table
    match '/tables/:table_id/error_tables/:id/edit(.:format)' => "error_tables#edit", :via => :get
    match '/tables/:table_id/error_tables/:id(.:format)' => "error_tables#update", :via => :put
    match '/tables/:table_id/error_tables/new(.:format)' => "error_tables#new", :via => :get
    match '/tables/:table_id/error_tables/:id/(.:format)' => "error_tables#show", :via => :get
    match '/tables/:table_id/error_tables/create(.:format)' => "error_tables#create", :via => :post
    match '/tables/:table_id/error_tables/:id/destroy(.:format)' => "error_tables#destroy", :via => :delete

    #Monitor_program
    match '/monitor_programs(/index)(.:format)' => "monitor_programs#index", :via => :get
    match '/monitor_programs/get_data(.:format)' => "monitor_programs#get_data"
    match '/monitor_programs/:id/edit(.:format)' => "monitor_programs#edit", :via => :get
    match '/monitor_programs/:id(.:format)' => "monitor_programs#update", :via => :put
    match '/monitor_programs/new(.:format)' => "monitor_programs#new", :via => :get
    match '/monitor_programs/:id(.:format)' => "monitor_programs#show", :via => :get
    match '/monitor_programs/create(.:format)' => "monitor_programs#create", :via => :post
    match '/monitor_programs/:id/get_target_data(.:format)' => "monitor_programs#get_target_data", :via => :get
    match '/monitor_programs/:id/create_target(.:format)' => "monitor_programs#create_target", :via => :post
    match '/monitor_programs/:id/new_target(.:format)' => "monitor_programs#new_target", :via => :get
    match '/monitor_programs/:id/remove_target(.:format)' => "monitor_programs#remove_target", :via => :delete
    match '/monitor_programs/:id/execute(.:format)' => "monitor_programs#execute"

    #Monitor_histories
    match '/monitor_programs/:program_id/histories(/index)(.:format)' => "monitor_histories#index", :via => :get
    match '/monitor_programs/:program_id/get_data(.:format)' => "monitor_histories#get_data", :via => :get
    match '/monitor_programs/:program_id/histories/:id(.:format)' => "monitor_histories#show", :via => :get

    #Connections
    match '/connections(/index)(.:format)' => "connections#index", :via => :get
    match '/connections/get_data(.:format)' => "connections#get_data"
    match '/connections/:id/edit(.:format)' => "connections#edit", :via => :get
    match '/connections/:id(.:format)' => "connections#update", :via => :put
    match '/connections/new(.:format)' => "connections#new", :via => :get
    match '/connections/:id(.:format)' => "connections#show", :via => :get
    match '/connections/:id/destroy(.:format)' => "connections#destroy", :via => :delete
    match '/connections/create(.:format)' => "connections#create", :via => :post

    #Database
    match '/databases(/index)(.:format)' => "databases#index", :via => :get
    match '/databases/get_data(.:format)' => "databases#get_data"
    match '/databases/:id/edit(.:format)' => "databases#edit", :via => :get
    match '/databases/:id(.:format)' => "databases#update", :via => :put
    match '/databases/new(.:format)' => "databases#new", :via => :get
    match '/databases/:id(.:format)' => "databases#show", :via => :get
    match '/databases/create(.:format)' => "databases#create", :via => :post

    #DatabaseItem
    match '/database_items(/index)(.:format)' => "database_items#index", :via => :get
    match '/database_items/get_data(.:format)' => "database_items#get_data"
    match '/database_items/:id/edit(.:format)' => "database_items#edit", :via => :get
    match '/database_items/:id(.:format)' => "database_items#update", :via => :put
    match '/database_items/new(.:format)' => "database_items#new", :via => :get
    match '/database_items/:id(.:format)' => "database_items#show", :via => :get
    match '/database_items/create(.:format)' => "database_items#create", :via => :post
    match '/database_items/:id/destroy(.:format)' => "database_items#destroy", :via => :delete
  end
end