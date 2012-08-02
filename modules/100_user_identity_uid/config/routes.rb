Ironmine::Application.routes.draw do
  scope :module => "uid" do
    #external_logins
    match '/external_logins(/index)(.:format)' => "external_logins#index", :via => :get
    match '/external_logins/get_data(.:format)' => "external_logins#get_data"
    match '/external_logins/:id/edit(.:format)' => "external_logins#edit", :via => :get
    match '/external_logins/:id(.:format)' => "external_logins#update", :via => :put
    match '/external_logins/new(.:format)' => "external_logins#new", :via => :get
    match '/external_logins/:id/show(.:format)' => "external_logins#show", :via => :get
    match '/external_logins/create(.:format)' => "external_logins#create", :via => :post
    match '/external_logins/:id/multilingual_edit(.:format)' => "external_logins#multilingual_edit", :via => :get
    match '/external_logins/:id/multilingual_update(.:format)' => "external_logins#multilingual_update", :via => :put
    match '/external_logins/:id/delete(.:format)' => "external_logins#destroy"

    #login_mappings
    match '/login_mappings(/index)(.:format)' => "login_mappings#index", :via => :get
    match '/login_mappings/get_data(.:format)' => "login_mappings#get_data"
    match '/login_mappings/:id/edit(.:format)' => "login_mappings#edit", :via => :get
    match '/login_mappings/:id(.:format)' => "login_mappings#update", :via => :put
    match '/login_mappings/new(.:format)' => "login_mappings#new", :via => :get
    match '/login_mappings/:id/show(.:format)' => "login_mappings#show", :via => :get
    match '/login_mappings/create(.:format)' => "login_mappings#create", :via => :post
    match '/login_mappings/not_mpping_external_logins(.:format)' => "login_mappings#not_mpping_external_logins", :via => :get
    match '/login_mappings/:id/delete(.:format)' => "login_mappings#destroy"
    #auto_mappings
    match '/auto_mappings(/index)(.:format)' => "auto_mappings#index", :via => :get
    match '/auto_mappings/get_data(.:format)' => "auto_mappings#get_data"
    match '/auto_mappings/confirm(.:format)' => "auto_mappings#confirm"
    match '/auto_mappings/:id/edit(.:format)' => "auto_mappings#edit", :via => :get
    match '/auto_mappings/:id(.:format)' => "auto_mappings#update", :via => :put
    match '/auto_mappings/new(.:format)' => "auto_mappings#new", :via => :get
    match '/auto_mappings/:id(.:format)' => "auto_mappings#show", :via => :get
    match '/auto_mappings/create(.:format)' => "auto_mappings#create", :via => :post
    #import_files
    match '/import_files(/index)(.:format)' => "import_files#index", :via => :get
    match '/import_files/get_data(.:format)' => "import_files#get_data"
    match '/import_files/:id/edit(.:format)' => "import_files#edit", :via => :get
    match '/import_files/:id(.:format)' => "import_files#update", :via => :put
    match '/import_files/new(.:format)' => "import_files#new", :via => :get
    match '/import_files/:id(.:format)' => "import_files#show", :via => :get
    match '/import_files/create(.:format)' => "import_files#create", :via => :post
    #system_user_home
    match '/system_user_home(/index)(.:format)' => "system_user_home#index", :via => :get
    #external_user_home
    match '/external_user_home(/index)(.:format)' => "external_user_home#index", :via => :get
  end
end
