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
  end
end