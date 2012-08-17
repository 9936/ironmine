Rails.application.routes.draw do
  scope :module => "irm" do
    #rating_configs
    match '/rating_configs(/index)(.:format)' => "rating_configs#index", :via => :get
    match '/rating_configs/:id/edit(.:format)' => "rating_configs#edit", :via => :get
    match '/rating_configs/:id(.:format)' => "rating_configs#update", :via => :put
    match '/rating_configs/new(.:format)' => "rating_configs#new", :via => :get
    match '/rating_configs/create(.:format)' => "rating_configs#create", :via => :post
    match '/rating_configs/get_data(.:format)' => "rating_configs#get_data"
    match '/rating_configs/:id/show(.:format)' => "rating_configs#show", :via => :get
  end

  scope :module => "irm" do
    root :to => "navigations#index"
    match 'login' => 'common#login', :as => :login
    match 'combo' => 'navigations#combo'
    match 'access_deny' => 'navigations#access_deny'
    match 'logout' => 'common#logout', :as => :logout
    match 'forgot_password' => "common#forgot_password"
    match 'send_email' => "common#send_email", :via => :post
    match 'reset_pwd' => "common#reset_pwd"
    match 'update_pwd' => "common#update_pwd", :via => :post
    match 'edit_password/:id' => "common#edit_password", :via => :get
    match 'update_password/:id' => "common#update_password", :via => :put
    match 'common/search_options' => "common#search_options"
    match 'common/upload_screen_shot' => "common#upload_screen_shot", :via => :get
    match 'common/upload_file(.:format)' => "common#upload_file", :via => :get
    match 'common/create_upload_file(.:format)' => "common#create_upload_file", :via => :post
    match 'search(/index)(.:format)' => "search#index", :via => [:get, :post]
    #lookup_types
    match '/lookup_types/new(.:format)' => "lookup_types#new", :via => :get
    match '/lookup_types/create(.:format)' => "lookup_types#create", :via => :post
    match '/lookup_types/create_value(.:format)' => "lookup_types#create_value", :via => :post
    match '/lookup_types/create_edit_value(.:format)' => "lookup_types#create_edit_value", :via => :post
    match '/lookup_types/get_lookup_types(.:format)' => "lookup_types#get_lookup_types", :via => :get
    match '/lookup_types/get_lookup_values(.:format)' => "lookup_types#get_lookup_values", :via => :get
    match '/lookup_types(/index)(.:format)' => "lookup_types#index", :via => :get
    match '/lookup_types/:id/edit(.:format)' => "lookup_types#edit", :via => :get
    match '/lookup_types/:id/multilingual_edit(.:format)' => "lookup_types#multilingual_edit", :via => :get
    match '/lookup_types/:id/multilingual_update(.:format)' => "lookup_types#multilingual_update", :via => :put
    match '/lookup_types/:id' => "lookup_types#update", :via => :put
    match '/lookup_types/check_lookup_code' => "lookup_types#check_lookup_code"
    match '/lookup_types/:id/add_code' => "lookup_types#add_code"
    match '/lookup_types/:id(.:format)' => "lookup_types#show"

    #product modules
    match '/product_modules(/index)(.:format)' => "product_modules#index", :via => :get
    match '/product_modules/:id/edit(.:format)' => "product_modules#edit", :via => :get
    match '/product_modules/:id(.:format)' => "product_modules#update", :via => :put
    match '/product_modules/new(.:format)' => "product_modules#new", :via => :get
    match '/product_modules/create(.:format)' => "product_modules#create", :via => :post
    match '/product_modules/get_data(.:format)' => "product_modules#get_data"
    #languages
    match '/languages(/index)(.:format)' => "languages#index", :via => :get
    match '/languages/get_data(.:format)' => "languages#get_data"
    match '/languages/:id/edit(.:format)' => "languages#edit", :via => :get
    match '/languages/:id(.:format)' => "languages#update", :via => :put
    match '/languages/new(.:format)' => "languages#new", :via => :get
    match '/languages/:id(.:format)' => "languages#show", :via => :get
    match '/languages/create(.:format)' => "languages#create", :via => :post
    match '/languages/:id/multilingual_edit(.:format)' => "languages#multilingual_edit", :via => :get
    match '/languages/:id/multilingual_update(.:format)' => "languages#multilingual_update", :via => :put

    #menus
    match '/menus(/index)(.:format)' => "menus#index", :via => :get
    match '/menus/new(.:format)' => "menus#new", :via => :get
    match '/menus/create(.:format)' => "menus#create", :via => :post
    match '/menus/get_data(.:format)' => "menus#get_data"
    match '/menus/:id/edit(.:format)' => "menus#edit", :via => :get
    match '/menus/:id(.:format)' => "menus#update", :via => :put
    match '/menus/:id/show(.:format)' => "menus#show", :via => :get
    match '/menus/:entry_id/:id/remove_entry(.:format)' => "menus#remove_entry"
    match '/menus/:id/multilingual_edit(.:format)' => "menus#multilingual_edit", :via => :get
    match '/menus/:id/multilingual_update(.:format)' => "menus#multilingual_update", :via => :put

    #menu_entries
    match '/menu_entries(/index)(.:format)' => "menu_entries#index", :via => :get
    match '/menu_entries/:menu_id/new(.:format)' => "menu_entries#new", :via => :get
    match '/menu_entries/create(.:format)' => "menu_entries#create", :via => :post
    match '/menu_entries/:menu_id/get_data(.:format)' => "menu_entries#get_data"
    match '/menu_entries/:id/edit(.:format)' => "menu_entries#edit", :via => :get
    match '/menu_entries/:id(.:format)' => "menu_entries#update", :via => :put
    match '/menu_entries/destroy(.:format)' => "menu_entries#destroy"
    match '/menu_entries/select_parent(.:format)' => "menu_entries#select_parent"
    match '/menu_entries/:id/show(.:format)' => "menu_entries#show", :via => :get
    match '/menu_entries/:id/multilingual_edit(.:format)' => "menu_entries#multilingual_edit", :via => :get
    match '/menu_entries/:id/multilingual_update(.:format)' => "menu_entries#multilingual_update", :via => :put

    #functions
    match '/functions(/index)(.:format)' => "functions#index", :via => :get
    match '/functions/:id/edit(.:format)' => "functions#edit", :via => :get
    match '/functions/:id(.:format)' => "functions#update", :via => :put
    match '/functions/new(.:format)' => "functions#new", :via => :get
    match '/functions/create(.:format)' => "functions#create", :via => :post
    match '/functions/:id/show(.:format)' => "functions#show", :via => :get
    match '/functions/get_data(.:format)' => "functions#get_data"
    match '/functions/:function_id/add_permissions(.:format)' => "functions#add_permissions", :via => :get
    match '/functions/:function_code/get_available_permissions(.:format)' => "functions#get_available_permissions", :via => :get
    match '/functions/:function_id/select_permissions(.:format)' => "functions#select_permissions"
    match '/functions/:function_id/add_permissions(.:format)' => "functions#add_permissions", :via => :post
    match '/functions/:function_id/:permission_id/remove_permission(.:format)' => "functions#remove_permission", :via => :get
    match '/functions/:id/multilingual_edit(.:format)' => "functions#multilingual_edit", :via => :get
    match '/functions/:id/multilingual_update(.:format)' => "functions#multilingual_update", :via => :put

    #function_groups
    match '/function_groups(/index)(.:format)' => "function_groups#index", :via => :get
    match '/function_groups/:id/edit(.:format)' => "function_groups#edit", :via => :get
    match '/function_groups/:id(.:format)' => "function_groups#update", :via => :put
    match '/function_groups/new(.:format)' => "function_groups#new", :via => :get
    match '/function_groups/create(.:format)' => "function_groups#create", :via => :post
    match '/function_groups/:id/show(.:format)' => "function_groups#show", :via => :get
    match '/function_groups/get_data(.:format)' => "function_groups#get_data"
    match '/function_groups/:id/multilingual_edit(.:format)' => "function_groups#multilingual_edit", :via => :get
    match '/function_groups/:id/multilingual_update(.:format)' => "function_groups#multilingual_update", :via => :put

    #permissions
    match '/permissions(/index)(.:format)' => "permissions#index", :via => :get
    match '/permissions/:id/edit(.:format)' => "permissions#edit", :via => :get
    match '/permissions/:id(.:format)' => "permissions#update", :via => :put
    match '/permissions/new(.:format)' => "permissions#new", :via => :get
    match '/permissions/create(.:format)' => "permissions#create", :via => :post
    match '/permissions/:id/multilingual_edit(.:format)' => "permissions#multilingual_edit", :via => :get
    match '/permissions/:id/multilingual_update(.:format)' => "permissions#multilingual_update", :via => :put
    match '/permissions/:function_code/function_get_data(.:format)' => "permissions#function_get_data"
    match '/permissions/get_data(.:format)' => "permissions#get_data"
    match '/permissions/:id/show(.:format)' => "permissions#show", :via => :get
    match '/permissions/data_grid(.:format)' => "permissions#data_grid", :via => :get

    #lookup_values
    match '/lookup_values(/index)(.:format)' => "lookup_values#index", :via => :get
    match '/lookup_values/get_data(.:format)' => "lookup_values#get_data"
    match '/lookup_values/:id/edit(.:format)' => "lookup_values#edit", :via => :get
    match '/lookup_values/:id(.:format)' => "lookup_values#update", :via => :put
    match '/lookup_values/new(.:format)' => "lookup_values#new", :via => :get
    match '/lookup_values/create(.:format)' => "lookup_values#create", :via => :post
    match '/lookup_values/get_lookup_values(.:format)' => "lookup_values#get_lookup_values", :via => :get
    match '/lookup_values/:id/multilingual_edit(.:format)' => "lookup_values#multilingual_edit", :via => :get
    match '/lookup_values/:id/multilingual_update(.:format)' => "lookup_values#multilingual_update", :via => :put
    match '/lookup_values/select_lookup_type(.:format)' => "lookup_values#select_lookup_type"
    match '/lookup_values/:id(.:format)' => "lookup_values#show", :via => :get

    #my_info
    match '/my_info(/index)(.:format)' => "my_info#index", :via => :get
    match '/my_info/edit(.:format)' => "my_info#edit", :via => :get
    match '/my_info/update(.:format)' => "my_info#update", :via => :put
    match '/my_info/get_my_remote_access(.:format)' => "my_info#get_my_remote_access"

    #my_profile
    match '/my_profiles(/index)(.:format)' => "my_profiles#index", :via => :get

    #my_password
    match '/my_password(.:format)' => "my_password#index", :via => :get
    match '/my_password/edit_password(.:format)' => "my_password#edit_password", :via => :get
    match '/my_password/update_password(.:format)' => "my_password#update_password", :via => :put

    #my_avatar
    match '/my_avatar(/index)(.:format)' => "my_avatar#index", :via => :get
    match '/my_avatar/edit(.:format)' => "my_avatar#edit", :via => :get
    match '/my_avatar/update(.:format)' => "my_avatar#update", :via => :put
    match '/my_avatar/:id/avatar_crop(.:format)' => "my_avatar#avatar_crop", :via => :get

    #my_login_history
    match '/my_login_history(/index)(.:format)' => "my_login_history#index", :via => :get
    match '/my_login_history/get_login_data(.:format)' => "my_login_history#get_login_data", :via => :get

    #global_settings
    match '/global_settings(/index)(.:format)' => "global_settings#index", :via => :get
    match '/global_settings/edit(.:format)' => "global_settings#edit", :via => :get
    match '/global_settings/update(.:format)' => "global_settings#update"
    match '/global_settings/crop(.:format)' => "global_settings#crop"

    #ldap_sources
    match '/ldap_sources(/index)(.:format)' => "ldap_sources#index", :via => :get
    match '/ldap_sources/:id/edit(.:format)' => "ldap_sources#edit", :via => :get
    match '/ldap_sources/:id/execute_test(.:format)' => "ldap_sources#execute_test", :via => :get
    match '/ldap_sources/:id/active(.:format)' => "ldap_sources#active", :via => :get
    match '/ldap_sources/:id(.:format)' => "ldap_sources#update", :via => :put
    match '/ldap_sources/new(.:format)' => "ldap_sources#new", :via => :get
    match '/ldap_sources/create(.:format)' => "ldap_sources#create", :via => :post
    match '/ldap_sources/get_data(.:format)' => "ldap_sources#get_data"
    match '/ldap_sources/:id/show(.:format)' => "ldap_sources#show", :via => :get

    #ldap_auth_headers
    match '/ldap_auth_headers(/index)(.:format)' => "ldap_auth_headers#index", :via => :get
    match '/ldap_auth_headers/:id/edit(.:format)' => "ldap_auth_headers#edit", :via => :get
    match '/ldap_auth_headers/:id(.:format)' => "ldap_auth_headers#update", :via => :put
    match '/ldap_auth_headers/new(.:format)' => "ldap_auth_headers#new", :via => :get
    match '/ldap_auth_headers/create(.:format)' => "ldap_auth_headers#create", :via => :post
    match '/ldap_auth_headers/get_data(.:format)' => "ldap_auth_headers#get_data"
    match '/ldap_auth_headers/:id/show(.:format)' => "ldap_auth_headers#show", :via => :get
    #ldap_auth_attributes
    match '/ldap_auth_attributes(/index)(.:format)' => "ldap_auth_attributes#index", :via => :get
    match '/ldap_auth_headers/:ah_id/ldap_auth_attributes/new(.:format)' => "ldap_auth_attributes#new", :via => [:get, :post, :put]
    match '/ldap_auth_headers/:ah_id/ldap_auth_attributes/create(.:format)' => "ldap_auth_attributes#create", :via => :post
    match '/ldap_auth_headers/:ah_id/ldap_auth_attributes/get_data(.:format)' => "ldap_auth_attributes#get_data"
    match '/ldap_auth_headers/:ah_id/ldap_auth_attributes/:id/edit(.:format)' => "ldap_auth_attributes#edit", :via => :get
    match '/ldap_auth_headers/:ah_id/ldap_auth_attributes/:id/update(.:format)' => "ldap_auth_attributes#update", :via => :put
    match '/ldap_auth_headers/:ah_id/ldap_auth_attributes/:id/show(.:format)' => "ldap_auth_attributes#show", :via => :get
    match '/ldap_auth_headers/:ah_id/ldap_auth_attributes/:id/delete(.:format)' => "ldap_auth_attributes#destroy"
    match '/ldap_auth_headers/get_by_ldap_source(.:format)' => "ldap_auth_headers#get_by_ldap_source", :via => :get

    #ldap_syn_header
    match '/ldap_syn_headers(/index)(.:format)' => "ldap_syn_headers#index", :via => :get
    match '/ldap_syn_headers/:id/edit(.:format)' => "ldap_syn_headers#edit", :via => :get
    match '/ldap_syn_headers/execute_test(.:format)' => "ldap_syn_headers#execute_test", :via => :get
    match '/ldap_syn_headers/:id/execute_test(.:format)' => "ldap_syn_headers#execute_test", :via => :get
    match '/ldap_syn_headers/:id(.:format)' => "ldap_syn_headers#update", :via => :put
    match '/ldap_syn_headers/new(.:format)' => "ldap_syn_headers#new", :via => :get
    match '/ldap_syn_headers/create(.:format)' => "ldap_syn_headers#create", :via => :post
    match '/ldap_syn_headers/:id/multilingual_edit(.:format)' => "ldap_syn_headers#multilingual_edit", :via => :get
    match '/ldap_syn_headers/:id/multilingual_update(.:format)' => "ldap_syn_headers#multilingual_update", :via => :put
    match '/ldap_syn_headers/get_data(.:format)' => "ldap_syn_headers#get_data"
    match '/ldap_syn_headers/:id/show(.:format)' => "ldap_syn_headers#show", :via => :get
    match '/ldap_syn_headers/:id/active(.:format)' => "ldap_syn_headers#active", :via => :get

    #ldap_syn_attributes
    match '/ldap_syn_attributes(/index)(.:format)' => "ldap_syn_attributes#index", :via => :get
    match '/ldap_syn_headers/:ah_id/:type/ldap_syn_attributes/new(.:format)' => "ldap_syn_attributes#new", :via => [:get, :post, :put]
    match '/ldap_syn_headers/:ah_id/:type/ldap_syn_attributes/create(.:format)' => "ldap_syn_attributes#create", :via => :post
    match '/ldap_syn_headers/:ah_id/:type/ldap_syn_attributes/get_data(.:format)' => "ldap_syn_attributes#get_data"
    match '/ldap_syn_headers/:ah_id/ldap_syn_attributes/:id/edit(.:format)' => "ldap_syn_attributes#edit", :via => :get
    match '/ldap_syn_headers/:ah_id/ldap_syn_attributes/:id/show(.:format)' => "ldap_syn_attributes#show", :via => :get
    match '/ldap_syn_headers/:ah_id/ldap_syn_attributes/:id(.:format)' => "ldap_syn_attributes#update", :via => :put
    match '/ldap_syn_headers/:ah_id/ldap_syn_attributes/:id/delete(.:format)' => "ldap_syn_attributes#destroy"

    # navigations
    match '/navigations/:application_id/change_application(.:format)' => "navigations#change_application", :via => :get
    #mail_templates
    match '/mail_templates/new(.:format)' => "mail_templates#new", :via => :get
    match '/mail_templates/get_data(.:format)' => "mail_templates#get_data"
    match '/mail_templates(.:format)' => "mail_templates#create", :via => :post
    match '/mail_templates(/index)(.:format)' => "mail_templates#index", :via => :get
    match '/mail_templates/:id/edit(.:format)' => "mail_templates#edit", :via => :get
    match '/mail_templates/:id(.:format)' => "mail_templates#update", :via => :put
    match '/mail_templates/:id/show(.:format)' => "mail_templates#show", :via => :get
    match '/mail_templates/get_script_context_fields(.:format)' => "mail_templates#get_script_context_fields", :via => :get
    match '/mail_templates/get_mail_templates(.:format)' => "mail_templates#get_mail_templates", :via => :get

    #currencies
    match '/currencies(/index)(.:format)' => "currencies#index", :via => :get
    match '/currencies/get_data(.:format)' => "currencies#get_data"
    match '/currencies/:id/edit(.:format)' => "currencies#edit", :via => :get
    match '/currencies/:id(.:format)' => "currencies#update", :via => :put
    match '/currencies/new(.:format)' => "currencies#new", :via => :get
    match '/currencies/:id(.:format)' => "currencies#show", :via => :get
    match '/currencies/create(.:format)' => "currencies#create", :via => :post
    match '/currencies/:id/multilingual_edit(.:format)' => "currencies#multilingual_edit", :via => :get
    match '/currencies/:id/multilingual_update(.:format)' => "currencies#multilingual_update", :via => :put

    #regions
    match '/regions(/index)(.:format)' => "regions#index", :via => :get
    match '/regions/get_data(.:format)' => "regions#get_data"
    match '/regions/:id/edit(.:format)' => "regions#edit", :via => :get
    match '/regions/:id(.:format)' => "regions#update", :via => :put
    match '/regions/new(.:format)' => "regions#new", :via => :get
    match '/regions/:id(.:format)' => "regions#show", :via => :get
    match '/regions/create(.:format)' => "regions#create", :via => :post
    match '/regions/:id/multilingual_edit(.:format)' => "regions#multilingual_edit", :via => :get
    match '/regions/:id/multilingual_update(.:format)' => "regions#multilingual_update", :via => :put

    #login_records
    match '/login_records(/index)(.:format)' => "login_records#index", :via => :get
    match '/login_records/get_data(.:format)' => "login_records#get_data"
    #organizations
    match '/organizations/get_data(.:format)' => "organizations#get_data"
    match '/organizations(/index)(.:format)' => "organizations#index", :via => :get
    match '/organizations/:id/edit(.:format)' => "organizations#edit", :via => :get
    match '/organizations/:id(.:format)' => "organizations#update", :via => :put
    match '/organizations/new(.:format)' => "organizations#new", :via => :get
    match '/organizations/:id/show(.:format)' => "organizations#show", :via => :get
    match '/organizations/create(.:format)' => "organizations#create", :via => :post
    match '/organizations/:id/multilingual_edit(.:format)' => "organizations#multilingual_edit", :via => :get
    match '/organizations/:id/multilingual_update(.:format)' => "organizations#multilingual_update", :via => :put
    match '/organizations/belongs_to(.:format)' => "organizations#belongs_to"
    match '/organizations/get_by_company(.:format)' => "organizations#get_by_company", :via => :get

    #organization_infos
    match '/organization_infos/get_data(.:format)' => "organization_infos#get_data"
    match '/organization_infos(/index)(.:format)' => "organization_infos#index", :via => :get
    match '/organization_infos/:id/edit(.:format)' => "organization_infos#edit", :via => :get
    match '/organization_infos/new(.:format)' => "organization_infos#new", :via => :get
    match '/organization_infos/:id/show(.:format)' => "organization_infos#show", :via => :get
    match '/organization_infos/create(.:format)' => "organization_infos#create", :via => :post
    match 'organization_infos/:id/update(.:format)' => "organization_infos#update", :via => :put
    match '/organization_infos/delete_attachment(.:format)' => "organization_infos#delete_attachment", :via => :post


    #flex_value_sets
    match '/flex_value_sets(/index)(.:format)' => "flex_value_sets#index", :via => :get
    match '/flex_value_sets/new(.:format)' => "flex_value_sets#new", :via => :get
    match '/flex_value_sets/create(.:format)' => "flex_value_sets#create", :via => :post
    match '/flex_value_sets/get_data(.:format)' => "flex_value_sets#get_data"
    match '/flex_value_sets/:id/edit(.:format)' => "flex_value_sets#edit", :via => :get
    match '/flex_value_sets/:id(.:format)' => "flex_value_sets#update", :via => :put
    match '/flex_value_sets/:id/show(.:format)' => "flex_value_sets#show", :via => :get
    #flex_values
    match '/flex_values(/index)(.:format)' => "flex_values#index", :via => :get
    match '/flex_values/:value_set_id/new(.:format)' => "flex_values#new", :via => :get
    match '/flex_values/create(.:format)' => "flex_values#create", :via => :post
    match '/flex_values/destroy(.:format)' => "flex_values#destroy"
    match 'flex_values/:id/show(.:format)' => "flex_values#show", :via => :get
    match '/flex_values/:id/edit(.:format)' => "flex_values#edit", :via => :get
    match '/flex_values/:value_set_id/get_data(.:format)' => "flex_values#get_data"
    match '/flex_values/:id(.:format)' => "flex_values#update", :via => :put
    match '/flex_values/select_set(.:format)' => "flex_values#select_set", :via => :post
    #site_groups
    match '/site_groups(/index)(.:format)' => "site_groups#index", :via => :get
    match '/site_groups/:id/edit(.:format)' => "site_groups#edit", :via => :get
    match '/site_groups/:id/update(.:format)' => "site_groups#update", :via => :put
    match '/site_groups/new(.:format)' => "site_groups#new", :via => :get
    match '/site_groups/create(.:format)' => "site_groups#create", :via => :post
    match '/site_groups/:id/multilingual_edit(.:format)' => "site_groups#multilingual_edit", :via => :get
    match '/site_groups/:id/multilingual_update(.:format)' => "site_groups#multilingual_update", :via => :put
    match '/site_groups/get_data(.:format)' => "site_groups#get_data"
    match '/site_groups/get_current_group_site(.:format)' => "site_groups#get_current_group_site"
    match '/site_groups/create_site(.:format)' => "site_groups#create_site"
    match '/site_groups/belongs_to(.:format)' => "site_groups#belongs_to"
    match '/site_groups/:id/show(.:format)' => "site_groups#show"
    match '/site_groups/:id/add_site(.:format)' => "site_groups#add_site"
    match '/site_groups/:id/edit_site(.:format)' => "site_groups#edit_site"
    match '/site_groups/:id/update_site(.:format)' => "site_groups#update_site"
    match '/site_groups/:id/current_site_group(.:format)' => "site_groups#current_site_group"
    match '/site_groups/:id/multilingual_site_edit(.:format)' => "site_groups#multilingual_site_edit", :via => :get
    match '/site_groups/:id/multilingual_site_update(.:format)' => "site_groups#multilingual_site_update", :via => :put
    match '/site_groups/get_by_region_code(.:format)' => "site_groups#get_by_region_code", :via => :get

    #general_categories
    match '/general_categories(/index)(.:format)' => "general_categories#index", :via => :get
    match '/general_categories/new(.:format)' => "general_categories#new"
    match '/general_categories/create(.:format)' => "general_categories#create", :via => :post
    match '/general_categories/get_data(.:format)' => "general_categories#get_data"
    match '/general_categories/:id/edit(.:format)' => "general_categories#edit", :via => :get
    match '/general_categories/:id(.:format)' => "general_categories#update", :via => :put
    match '/general_categories/update_segment_options(.:format)' => "general_categories#update_segment_options"
    match '/general_categories/:id/show(.:format)' => "general_categories#show", :via => :get
    #groups
    match '/groups(/index)(.:format)' => "groups#index", :via => :get
    match '/groups/:id/edit(.:format)' => "groups#edit", :via => :get
    match '/groups/:id(.:format)' => "groups#update", :via => :put
    match '/groups/new(.:format)' => "groups#new", :via => :get
    match '/groups/create(.:format)' => "groups#create", :via => :post
    match '/groups/:id/multilingual_edit(.:format)' => "groups#multilingual_edit", :via => :get
    match '/groups/:id/multilingual_update(.:format)' => "groups#multilingual_update", :via => :put
    match '/groups/:id(.:format)' => "groups#show"
    match '/groups/:id/new_skm_channels(.:format)' => "groups#new_skm_channels", :via => :get
    match '/groups/:id/create_skm_channels(.:format)' => "groups#create_skm_channels"
    match '/groups/:id/remove_skm_channel(.:format)' => "groups#remove_skm_channel"
    #group_members
    match '/group_members/:id/new(.:format)' => "group_members#new", :via => :get
    match '/group_members/:id/create(.:format)' => "group_members#create", :via => :post
    match '/group_members/:id/get_data(.:format)' => "group_members#get_data", :via => :get
    match '/group_members/:id/get_memberable_data(.:format)' => "group_members#get_memberable_data", :via => :get
    match '/group_members/:id/delete(.:format)' => "group_members#delete"
    match '/group_members/:id/new_from_person(.:format)' => "group_members#new_from_person", :via => :get
    match '/group_members/:id/get_groupable_data(.:format)' => "group_members#get_groupable_data", :via => :get
    match '/group_members/:id/create_from_person(.:format)' => "group_members#create_from_person", :via => :post
    match '/group_members/:id/get_data_from_person(.:format)' => "group_members#get_data_from_person", :via => :get
    match '/group_members/:id/:person_id/delete_from_person(.:format)' => "group_members#delete_from_person"
    #sites
    match '/sites(/index)(.:format)' => "sites#index", :via => :get
    match '/sites/get_data(.:format)' => "sites#get_data"
    match '/sites/:id/edit(.:format)' => "sites#edit", :via => :get
    match '/sites/:id/update(.:format)' => "sites#update", :via => :put
    match '/sites/new(.:format)' => "sites#new", :via => :get
    match '/sites/:id/show(.:format)' => "sites#show", :via => :get
    match '/sites/create(.:format)' => "sites#create", :via => :post
    match '/sites/select_site(.:format)' => "sites#select_site", :via => :post
    match '/sites/:id/multilingual_edit(.:format)' => "sites#multilingual_edit", :via => :get
    match '/sites/:id/multilingual_update(.:format)' => "sites#multilingual_update", :via => :put
    match '/sites/get_by_site_group_code(.:format)' => "sites#get_by_site_group_code", :via => :get
    #people
    match '/people/get_choose_people(.:format)' => "people#get_choose_people"
    match '/people/get_support_group(.:format)' => "people#get_support_group"
    match '/people/get_data(.:format)' => "people#get_data"
    match '/people(/index)(.:format)' => "people#index", :via => :get
    match '/people/:id/edit(.:format)' => "people#edit", :via => :get
    match '/people/new(.:format)' => "people#new", :via => :get
    match '/people/:id' => "people#show", :via => :get
    match '/people/:id/reset_password' => "people#reset_password", :via => :get
    match '/people/:id(.:format)' => "people#update", :via => :put
    match '/people/create(.:format)' => "people#create", :via => :post
    match '/people/:id/multilingual_edit(.:format)' => "people#multilingual_edit", :via => :get
    match '/people/:id/multilingual_update(.:format)' => "people#multilingual_update", :via => :put
    match '/people/choose_company(.:format)' => "people#choose_company"
    match '/people/:id/get_available_roles(.:format)' => "people#get_available_roles", :via => :get
    match '/people/:id/select_roles(.:format)' => "people#select_roles", :via => :get
    match '/people/:id/add_roles(.:format)' => "people#add_roles", :via => :post
    match '/people/:person_id/:role_id/remove_role(.:format)' => "people#remove_role", :via => :get
    match '/people/:person_id/get_owned_roles(.:format)' => "people#get_owned_roles", :via => :get
    match '/people/:person_id/get_owned_external_systems(.:format)' => "people#get_owned_external_systems", :via => :get
    match '/people/:id/info_card(.:format)' => "people#info_card", :via => :get
    #id_flexes
    match '/id_flexes(/index)(.:format)' => "id_flexes#index", :via => :get
    match '/id_flexes/:id/edit(.:format)' => "id_flexes#edit", :via => :get
    match '/id_flexes/:id(.:format)' => "id_flexes#update", :via => :put
    match '/id_flexes/new(.:format)' => "id_flexes#new", :via => :get
    match '/id_flexes/create(.:format)' => "id_flexes#create", :via => :post
    match '/id_flexes/get_data(.:format)' => "id_flexes#get_data"
    match '/id_flexes/:id/show(.:format)' => "id_flexes#show", :via => :get
    #id_flex_stuctures
    match '/id_flex_structures(/index)(.:format)' => "id_flex_structures#index", :via => :get
    match '/id_flex_structures/:id_flex_code/get_data(.:format)' => "id_flex_structures#get_data"
    match '/id_flex_structures/select_parent(.:format)' => 'id_flex_structures#select_parent'
    match '/id_flex_structures/:id/edit(.:format)' => "id_flex_structures#edit", :via => :get
    match '/id_flex_structures/:id(.:format)' => "id_flex_structures#update", :via => :put
    match '/id_flex_structures/:id_flex_code/new(.:format)' => "id_flex_structures#new", :via => :get
    match '/id_flex_structures/create(.:format)' => "id_flex_structures#create", :via => :post
    match '/id_flex_structures/:id/show(.:format)' => "id_flex_structures#show", :via => :get
    #id_flex_segments
    match '/id_flex_segments(/index)(.:format)' => "id_flex_segments#index", :via => :get
    match '/id_flex_segments/get_data(.:format)' => "id_flex_segments#get_data"
    match '/id_flex_segments/:id/edit(.:format)' => "id_flex_segments#edit", :via => :get
    match '/id_flex_segments/:id(.:format)' => "id_flex_segments#update", :via => :put
    match '/id_flex_segments/:id_flex_code/:id_flex_num/new(.:format)' => "id_flex_segments#new", :via => :get
    match '/id_flex_segments/create(.:format)' => "id_flex_segments#create", :via => :post
    match '/id_flex_segments/:id/show(.:format)' => "id_flex_segments#show", :via => :get


    #locations
    match '/locations(/index)(.:format)' => "locations#index", :via => :get
    match '/locations/get_data(.:format)' => "locations#get_data"
    match '/locations/:id/edit(.:format)' => "locations#edit", :via => :get
    match '/locations/:id(.:format)' => "locations#update", :via => :put
    match '/locations/new(.:format)' => "locations#new", :via => :get
    match '/locations/:id(.:format)' => "locations#show", :via => :get
    match '/locations/create(.:format)' => "locations#create", :via => :post
    # setting
    match '/setting(/index)(.:format)' => 'setting#index'
    match '/setting/:mi/common(.:format)' => 'setting#common'
    #home
    match '/home(/index)(.:format)' => "home#index", :via => :get
    match '/home/my_tasks(.:format)' => "home#my_tasks", :via => :get

    #view_filter
    match '/filters/index/:sc/:bc(.:format)' => "filters#index", :via => :get
    match '/filters/new/:sc/:bc(.:format)' => "filters#new", :via => :get
    match '/filters/create(.:format)' => "filters#create", :via => :post
    match '/filters/:id/edit(.:format)' => "filters#edit", :via => :get
    match '/filters/:id(.:format)' => "filters#update", :via => :put
    match '/filters/operator_value(.:format)' => "filters#operator_value", :via => :get
    #role
    match '/roles(/index)(.:format)' => "roles#index", :via => :get
    match '/roles/:id/edit(.:format)' => "roles#edit", :via => :get
    match '/roles/:id(.:format)' => "roles#update", :via => :put
    match '/roles/new(.:format)' => "roles#new", :via => :get
    match '/roles/create(.:format)' => "roles#create", :via => :post
    match '/roles/:id/edit_assignment(.:format)' => "roles#edit_assignment", :via => :get
    match '/roles/:id/update_assignment(.:format)' => "roles#update_assignment", :via => [:put, :post]
    match '/roles/:id/assignable_people(.:format)' => "roles#assignable_people", :via => :get
    match '/roles/:id/role_people(.:format)' => "roles#role_people", :via => :get
    match '/roles/:id/delete_people(.:format)' => "roles#delete_people"

    match '/roles/:id/show(.:format)' => "roles#show", :via => :get
    match '/roles/:id/multilingual_edit(.:format)' => "roles#multilingual_edit", :via => :get
    match '/roles/:id/multilingual_update(.:format)' => "roles#multilingual_update", :via => :put
    #reports
    match '/reports(/index)(.:format)' => "reports#index", :via => [:get, :post, :put]
    match '/reports/:id/edit(.:format)' => "reports#edit", :via => [:get, :post, :put]
    match '/reports/:id(.:format)' => "reports#update", :via => :put
    match '/reports/new(.:format)' => "reports#new", :via => [:get, :post]
    match '/reports/:id/run(.:format)' => "reports#run", :via => :put
    match '/reports/operator_value(.:format)' => "reports#operator_value", :via => :get
    match '/reports/create(.:format)' => "reports#create", :via => :post
    match '/reports/get_data(.:format)' => "reports#get_data"
    match '/reports/:id/show(.:format)' => "reports#show", :via => :get
    match '/reports/:id/multilingual_edit(.:format)' => "reports#multilingual_edit", :via => :get
    match '/reports/:id/multilingual_update(.:format)' => "reports#multilingual_update", :via => :put
    match '/reports/:id/destroy(.:format)' => "reports#destroy"
    match '/reports/:id/edit_custom(.:format)' => "reports#edit_custom", :via => [:get, :post, :put]
    match '/reports/:id/update_custom(.:format)' => "reports#update_custom", :via => :put
    match '/reports/new_program(.:format)' => "reports#new_program", :via => [:get, :post]
    match '/reports/create_program(.:format)' => "reports#create_program", :via => [:get, :post]
    match '/reports/:id/edit_program(.:format)' => "reports#edit_program", :via => [:get, :post, :put]
    match '/reports/:id/update_program(.:format)' => "reports#update_program", :via => :put
    match '/reports/:id/edit_custom_program(.:format)' => "reports#edit_custom_program", :via => [:get, :post, :put]
    match '/reports/:id/update_custom_program(.:format)' => "reports#update_custom_program", :via => :put
    match '/reports/portlet(.:format)' => "reports#portlet", :via => :get
    match '/reports/get_reports_tree(.:format)' => "reports#get_reports_tree", :via => :get

    #report folders
    match '/report_folders(/index)(.:format)' => "report_folders#index", :via => :get
    match '/report_folders/:id/edit(.:format)' => "report_folders#edit", :via => :get
    match '/report_folders/:id(.:format)' => "report_folders#update", :via => :put
    match '/report_folders/new(.:format)' => "report_folders#new", :via => :get
    match '/report_folders/create(.:format)' => "report_folders#create", :via => :post
    match '/report_folders/:id/multilingual_edit(.:format)' => "report_folders#multilingual_edit", :via => :get
    match '/report_folders/:id/multilingual_update(.:format)' => "report_folders#multilingual_update", :via => :put

    #report_request_histories
    match '/report_request_histories(/index)(.:format)' => "report_request_histories#index", :via => :get
    match '/report_request_histories/get_data(.:format)' => "report_request_histories#get_data", :via => :get


    #report triggers
    match '/report_triggers(/index)(.:format)' => "report_triggers#index", :via => :get
    match '/report_triggers/:id/edit(.:format)' => "report_triggers#edit", :via => :get
    match '/report_triggers/:id(.:format)' => "report_triggers#update", :via => :put
    match '/report_triggers/:report_id/new(.:format)' => "report_triggers#new", :via => :get
    match '/report_triggers/:report_id/create(.:format)' => "report_triggers#create", :via => :post
    match '/report_triggers/:id/destroy(.:format)' => "report_triggers#destroy"

    #bulletins
    match '/bulletins/new(.:format)' => "bulletins#new", :via => :get
    match '/bulletins/create(.:format)' => "bulletins#create", :via => :post
    match '/bulletins/:id/edit(.:format)' => "bulletins#edit", :via => :get
    match '/bulletins/:id(.:format)' => "bulletins#update", :via => :put
    match '/bulletins/get_data(.:format)' => "bulletins#get_data"
    match '/bulletins/index(.:format)' => "bulletins#index"
    match '/bulletins/:id/show(.:format)' => "bulletins#show", :via => :get
    match '/bulletins/:id/destroy(.:format)' => "bulletins#destroy"
    match '/bulletins/portlet(.:format)' => "bulletins#portlet", :via => :get

    match '/bulletins/:att_id/remove_exits_attachments' => "bulletins#remove_exits_attachments", :via => :get
    #bulletin_columns
    match '/bu_columns(/index)(.:format)' => "bu_columns#index", :via => :get
    match '/bu_columns/new(.:format)' => "bu_columns#new", :via => :get
    match '/bu_columns/create(.:format)' => "bu_columns#create", :via => :post
    match '/bu_columns/:id/edit(.:format)' => "bu_columns#edit", :via => :get
    match '/bu_columns/:id/update(.:format)' => "bu_columns#update", :via => :put
    match '/bu_columns/get_columns_data(.:format)' => "bu_columns#get_columns_data", :via => :get

    match '/watchers/:watchable_id/add_watcher(.:format)' => "watchers#add_watcher"
    match '/watchers/delete_watcher(.:format)' => "watchers#delete_watcher"
    match '/watchers/order(.:format)' => "watchers#order"

    #    match '/calendar_tasks(/:year(/:month))' => 'calendar_tasks#index', :as => :calendar_task, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
    match '/todo_events(/index)(.:format)' => "todo_events#index", :via => :get
    match '/todo_events/new(.:format)' => "todo_events#new", :via => :get
    match '/todo_events/create(.:format)' => "todo_events#create", :via => :post
    match '/todo_events/:id/edit(.:format)' => "todo_events#edit", :via => :get
    match '/todo_events/:id(.:format)' => "todo_events#update", :via => :put
    match '/todo_events/get_data(.:format)' => "todo_events#get_data"
    match '/todo_events/get_top_data(.:format)' => "todo_events#get_top_data"
    match '/todo_events/:id/show(.:format)' => "todo_events#show", :via => :get
    match '/todo_events/:id/edit_recurrence(.:format)' => "todo_events#edit_recurrence", :via => :get
    match '/todo_events/:id/update_recurrence(.:format)' => "todo_events#update_recurrence", :via => :put
    match '/todo_events/:id/quick_show(.:format)' => "todo_events#quick_show", :via => :get
    match '/todo_events/my_events_index(.:format)' => "todo_events#my_events_index", :via => :get
    match '/todo_events/my_events_get_data(.:format)' => "todo_events#my_events_get_data"
    match '/todo_events/calendar_view(.:format)' => "todo_events#calendar_view"

    match '/todo_tasks(/index)(.:format)' => "todo_tasks#index", :via => :get
    match '/todo_tasks/new(.:format)' => "todo_tasks#new", :via => :get
    match '/todo_tasks/create(.:format)' => "todo_tasks#create", :via => :post
    match '/todo_tasks/:id/edit(.:format)' => "todo_tasks#edit", :via => :get
    match '/todo_tasks/:id(.:format)' => "todo_tasks#update", :via => :put
    match '/todo_tasks/get_data(.:format)' => "todo_tasks#get_data"
    match '/todo_tasks/get_top_data(.:format)' => "todo_tasks#get_top_data"
    match '/todo_tasks/:id/show(.:format)' => "todo_tasks#show", :via => :get
    match '/todo_tasks/:id/edit_recurrence(.:format)' => "todo_tasks#edit_recurrence", :via => :get
    match '/todo_tasks/:id/update_recurrence(.:format)' => "todo_tasks#update_recurrence", :via => :put
    match '/todo_tasks/my_tasks_index(.:format)' => "todo_tasks#my_tasks_index", :via => :get
    match '/todo_tasks/my_tasks_get_data(.:format)' => "todo_tasks#my_tasks_get_data"
    match '/todo_tasks/portlet(.:format)' => "todo_tasks#portlet", :via => :get

    match '/calendars(/:year(/:month))' => 'calendars#get_full_calendar', :as => :calendar_task, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
    # business object
    match '/business_objects(/index)(.:format)' => "business_objects#index", :via => :get
    match '/business_objects/new(.:format)' => "business_objects#new", :via => :get
    match '/business_objects/create(.:format)' => "business_objects#create", :via => :post
    match '/business_objects/get_data(.:format)' => "business_objects#get_data"
    match '/business_objects/:id/edit(.:format)' => "business_objects#edit", :via => :get
    match '/business_objects/:id(.:format)' => "business_objects#update", :via => :put
    match '/business_objects/:id/show(.:format)' => "business_objects#show", :via => :get
    match '/business_objects/:id/execute_test(.:format)' => "business_objects#execute_test", :via => :get
    match '/business_objects/:id/multilingual_edit(.:format)' => "business_objects#multilingual_edit", :via => :get
    match '/business_objects/:id/multilingual_update(.:format)' => "business_objects#multilingual_update", :via => :put
    match '/business_objects/:id/destroy(.:format)' => "business_objects#destroy", :via => :delete
    # object attributes
    match '/object_attributes(/index)(.:format)' => "object_attributes#index", :via => :get
    match '/business_objects/:bo_id/object_attributes/new_model_attribute(.:format)' => "object_attributes#new_model_attribute", :via => :get
    match '/business_objects/:bo_id/object_attributes/create_model_attribute(.:format)' => "object_attributes#create_model_attribute", :via => :post
    match '/business_objects/:bo_id/object_attributes/new(.:format)' => "object_attributes#new", :via => [:get, :post, :put]
    match '/business_objects/:bo_id/object_attributes/create(.:format)' => "object_attributes#create", :via => :post
    match '/business_objects/:bo_id/object_attributes/get_data(.:format)' => "object_attributes#get_data"
    match '/business_objects/:bo_id/object_attributes/get_standard_data(.:format)' => "object_attributes#get_standard_data"
    match '/business_objects/:bo_id/object_attributes/:id/edit(.:format)' => "object_attributes#edit", :via => [:get, :put]
    match '/business_objects/:bo_id/object_attributes/:id(.:format)' => "object_attributes#update", :via => :put
    match '/business_objects/:bo_id/object_attributes/:id/show(.:format)' => "object_attributes#show", :via => :get
    match '/business_objects/:bo_id/object_attributes/:id/delete(.:format)' => "object_attributes#destroy"
    match '/business_objects/:bo_id/object_attributes/:id/multilingual_edit(.:format)' => "object_attributes#multilingual_edit", :via => :get
    match '/business_objects/:bo_id/object_attributes/:id/multilingual_update(.:format)' => "object_attributes#multilingual_update", :via => :put
    match '/business_objects/:bo_id/object_attributes/:id/change_type(.:format)' => "object_attributes#change_type", :via => :get
    match '/object_attributes/relation_columns(.:format)' => "object_attributes#relation_columns", :via => :get
    match '/object_attributes/selectable_columns(.:format)' => "object_attributes#selectable_columns", :via => :get
    match '/object_attributes/all_columns(.:format)' => "object_attributes#all_columns", :via => :get
    match '/object_attributes/updateable_columns(.:format)' => "object_attributes#updateable_columns", :via => :get
    match '/object_attributes/person_columns(.:format)' => "object_attributes#person_columns", :via => :get
    # search layouts
    match '/business_objects/:bo_id/search_layouts/new(.:format)' => "search_layouts#new", :via => :get
    match '/business_objects/:bo_id/search_layouts/create(.:format)' => "search_layouts#create", :via => :post
    match '/business_objects/:bo_id/search_layouts/:id/edit(.:format)' => "search_layouts#edit", :via => :get
    match '/business_objects/:bo_id/search_layouts/:id(.:format)' => "search_layouts#update", :via => :put
    # list of values
    match '/list_of_values(/index)(.:format)' => "list_of_values#index", :via => :get
    match '/list_of_values/new(.:format)' => "list_of_values#new", :via => :get
    match '/list_of_values/create(.:format)' => "list_of_values#create", :via => :post
    match '/list_of_values/get_data(.:format)' => "list_of_values#get_data"
    match '/list_of_values/:id/edit(.:format)' => "list_of_values#edit", :via => :get
    match '/list_of_values/:id(.:format)' => "list_of_values#update", :via => :put
    match '/list_of_values/:id/show(.:format)' => "list_of_values#show", :via => :get
    match '/list_of_values/:id/multilingual_edit(.:format)' => "list_of_values#multilingual_edit", :via => :get
    match '/list_of_values/:id/multilingual_update(.:format)' => "list_of_values#multilingual_update", :via => :put
    match '/list_of_values/:id/execute_test(.:format)' => "list_of_values#execute_test", :via => :get
    match '/list_of_values/:id/get_lov_data(.:format)' => "list_of_values#get_lov_data", :via => :get
    match '/list_of_values/:id/get_lov_data(.:format)' => "list_of_values#get_lov_data", :via => :get
    match '/list_of_values/:lktp/lov(.:format)' => "list_of_values#lov", :via => :get
    match '/list_of_values/:lktp/lov_search(.:format)' => "list_of_values#lov_search", :via => :get
    match '/list_of_values/:lktp/lov_result(.:format)' => "list_of_values#lov_result", :via => :get
    match '/list_of_values/:lktp/lov_value(.:format)' => "list_of_values#lov_value", :via => :get
    # wf_settings
    match '/wf_settings(/index)(.:format)' => "wf_settings#index", :via => :get
    match '/wf_settings/edit(.:format)' => "wf_settings#edit", :via => :get
    match '/wf_settings(.:format)' => "wf_settings#update", :via => :put
    # wf_rules
    match '/wf_rules(/index)(.:format)' => "wf_rules#index", :via => :get
    match '/wf_rules/new(.:format)' => "wf_rules#new", :via => [:get, :post, :put]
    match '/wf_rules/create(.:format)' => "wf_rules#create", :via => :post
    match '/wf_rules/get_data(.:format)' => "wf_rules#get_data"
    match '/wf_rules/:id/edit(.:format)' => "wf_rules#edit", :via => :get
    match '/wf_rules/:id/active(.:format)' => "wf_rules#active", :via => :get
    match '/wf_rules/:id(.:format)' => "wf_rules#update", :via => :put
    match '/wf_rules/:id/show(.:format)' => "wf_rules#show", :via => :get
    match '/wf_rules/:id/destroy_action(.:format)' => "wf_rules#destroy_action"
    match '/wf_rules/:id/add_exists_action(.:format)' => "wf_rules#add_exists_action", :via => :get
    match '/wf_rules/:id/save_exists_action(.:format)' => "wf_rules#save_exists_action", :via => :post
    match '/wf_rules/get_data_by_action(.:format)' => "wf_rules#get_data_by_action", :via => :get

    # wf_rule_time_triggers
    match '/wf_rules/:rule_id/wf_rule_time_triggers/new(.:format)' => "wf_rule_time_triggers#new", :via => :get
    match '/wf_rules/:rule_id/wf_rule_time_triggers/create(.:format)' => "wf_rule_time_triggers#create", :via => :post
    match '/wf_rules/:rule_id/wf_rule_time_triggers/:id/edit(.:format)' => "wf_rule_time_triggers#edit", :via => :get
    match '/wf_rules/:rule_id/wf_rule_time_triggers/:id(.:format)' => "wf_rule_time_triggers#update", :via => :put
    match '/wf_rules/:rule_id/wf_rule_time_triggers/:id/destroy(.:format)' => "wf_rule_time_triggers#destroy"

    #wf_field_updates
    match '/wf_field_updates(/index)(.:format)' => "wf_field_updates#index", :via => :get
    match '/wf_field_updates/:id/edit(.:format)' => "wf_field_updates#edit", :via => :get
    match '/wf_field_updates/:id(.:format)' => "wf_field_updates#update", :via => :put
    match '/wf_field_updates/new(.:format)' => "wf_field_updates#new", :via => :get
    match '/wf_field_updates/create(.:format)' => "wf_field_updates#create", :via => :post
    match '/wf_field_updates/get_data(.:format)' => "wf_field_updates#get_data"
    match '/wf_field_updates/:id/show(.:format)' => "wf_field_updates#show", :via => :get
    match '/wf_field_updates/:id/destroy(.:format)' => "wf_field_updates#destroy"
    match '/wf_field_updates/set_value(.:format)' => "wf_field_updates#set_value", :via => :get

    #formula_functions
    match '/formula_functions/formula_function_options(.:format)' => "formula_functions#formula_function_options", :via => :get
    match '/formula_functions/check_syntax(.:format)' => "formula_functions#check_syntax", :via => :get

    #wf_mail_alerts
    match '/wf_mail_alerts(/index)(.:format)' => "wf_mail_alerts#index", :via => :get
    match '/wf_mail_alerts/:id/edit(.:format)' => "wf_mail_alerts#edit", :via => :get
    match '/wf_mail_alerts/:id(.:format)' => "wf_mail_alerts#update", :via => :put
    match '/wf_mail_alerts/new(.:format)' => "wf_mail_alerts#new", :via => :get
    match '/wf_mail_alerts/create(.:format)' => "wf_mail_alerts#create", :via => :post
    match '/wf_mail_alerts/get_data(.:format)' => "wf_mail_alerts#get_data"
    match '/wf_mail_alerts/:id/show(.:format)' => "wf_mail_alerts#show", :via => :get
    match '/wf_mail_alerts/:id/destroy(.:format)' => "wf_mail_alerts#destroy"
    match '/wf_mail_alerts/recipient_source(.:format)' => "wf_mail_alerts#recipient_source", :via => :get
    # wf_approval_processes
    match '/wf_approval_processes(/index)(.:format)' => "wf_approval_processes#index", :via => :get
    match '/wf_approval_processes/new(.:format)' => "wf_approval_processes#new", :via => [:get, :post, :put]
    match '/wf_approval_processes/create(.:format)' => "wf_approval_processes#create", :via => :post
    match '/wf_approval_processes/get_data(.:format)' => "wf_approval_processes#get_data"
    match '/wf_approval_processes/:id/edit(.:format)' => "wf_approval_processes#edit", :via => [:get, :post, :put]
    match '/wf_approval_processes/:id/active(.:format)' => "wf_approval_processes#active", :via => :get
    match '/wf_approval_processes/:id(.:format)' => "wf_approval_processes#update", :via => :put
    match '/wf_approval_processes/:id/destroy(.:format)' => "wf_approval_processes#destroy"
    match '/wf_approval_processes/:id/show(.:format)' => "wf_approval_processes#show", :via => :get
    match '/wf_approval_processes/:id/destroy_action(.:format)' => "wf_approval_processes#destroy_action"
    match '/wf_approval_processes/:id/add_exists_action(.:format)' => "wf_approval_processes#add_exists_action", :via => :get
    match '/wf_approval_processes/:id/save_exists_action(.:format)' => "wf_approval_processes#save_exists_action", :via => :post
    match '/wf_approval_processes/reorder(.:format)' => "wf_approval_processes#reorder", :via => :post
    match '/wf_approval_processes/get_data_by_action(.:format)' => "wf_approval_processes#get_data_by_action", :via => :get

    # wf_approval_steps
    match '/wf_approval_steps(/index)(.:format)' => "wf_approval_steps#index", :via => :get
    match '/wf_approval_processes/:process_id/wf_approval_steps/new(.:format)' => "wf_approval_steps#new", :via => [:get, :post, :put]
    match '/wf_approval_processes/:process_id/wf_approval_steps/create(.:format)' => "wf_approval_steps#create", :via => :post
    match '/wf_approval_processes/:process_id/wf_approval_steps/:id/edit(.:format)' => "wf_approval_steps#edit", :via => [:get, :post, :put]
    match '/wf_approval_processes/:process_id/wf_approval_steps/:id(.:format)' => "wf_approval_steps#update", :via => :put
    match '/wf_approval_processes/:process_id/wf_approval_steps/:id/destroy(.:format)' => "wf_approval_steps#destroy"

    # wf process instance
    match '/wf_process_instances/submit(.:format)' => "wf_process_instances#submit", :via => [:get, :post]
    match '/wf_process_instances/:id/recall(.:format)' => "wf_process_instances#recall", :via => :get
    match '/wf_process_instances/:id/execute_recall(.:format)' => "wf_process_instances#execute_recall", :via => :put

    # wf step instance
    match '/wf_step_instances/:id/show(.:format)' => "wf_step_instances#show", :via => :get
    match '/wf_step_instances/:id/reassign(.:format)' => "wf_step_instances#reassign", :via => :get
    match '/wf_step_instances/submit(.:format)' => "wf_step_instances#submit", :via => [:post, :put]
    match '/wf_step_instances/save_reassign(.:format)' => "wf_step_instances#save_reassign", :via => :put

    #screen saver
    match '/attach_screenshot(/index)(.:format)' => "attach_screenshot#index"
    #
    #delayed_jobs
    match '/delayed_jobs(/index)(.:format)' => "delayed_jobs#index", :via => :get
    match '/delayed_jobs/:delayed_job_id/item_list(.:format)' => "delayed_jobs#item_list", :via => [:get, :post]
    match '/delayed_jobs/:delayed_job_id/item_view(.:format)' => "delayed_jobs#item_view", :via => [:get, :post]
    match '/delayed_jobs/action_process_monitor' => "delayed_job#action_process_monitor"
    match '/delayed_jobs/get_data(.:format)' => "delayed_jobs#get_data"
    match '/delayed_jobs/get_item_data(.:format)' => "delayed_jobs#get_item_data"

    match '/delayed_jobs/wf_process_job_monitor(.:format)' => "delayed_jobs#wf_process_job_monitor", :via => [:get, :post]
    match '/delayed_jobs/icm_group_assign_monitor(.:format)' => "delayed_jobs#icm_group_assign_monitor", :via => [:get, :post]
    match '/delayed_jobs/ir_rule_process_monitor(.:format)' => "delayed_jobs#ir_rule_process_monitor", :via => [:get, :post]

    match '/monitor_ir_rule_processes(/index)(.:format)' => "monitor_ir_rule_processes#index", :via => :get
    match '/monitor_icm_group_assigns(/index)(.:format)' => "monitor_icm_group_assigns#index", :via => :get
    match '/monitor_approval_mails(/index)(.:format)' => "monitor_approval_mails#index", :via => :get

    #report type categories
    match '/report_type_categories(/index)(.:format)' => "report_type_categories#index", :via => :get
    match '/report_type_categories/:id/edit(.:format)' => "report_type_categories#edit", :via => :get
    match '/report_type_categories/:id(.:format)' => "report_type_categories#update", :via => :put
    match '/report_type_categories/new(.:format)' => "report_type_categories#new", :via => :get
    match '/report_type_categories/create(.:format)' => "report_type_categories#create", :via => :post
    match '/report_type_categories/get_data(.:format)' => "report_type_categories#get_data"
    match '/report_type_categories/:id(.:format)' => "report_type_categories#show", :via => :get
    match '/report_type_categories/:id/multilingual_edit(.:format)' => "report_type_categories#multilingual_edit", :via => :get
    match '/report_type_categories/:id/multilingual_update(.:format)' => "report_type_categories#multilingual_update", :via => :put

    #report types
    match '/report_types(/index)(.:format)' => "report_types#index", :via => :get
    match '/report_types/:id/edit(.:format)' => "report_types#edit", :via => :get
    match '/report_types/:id(.:format)' => "report_types#update", :via => :put
    match '/report_types/:id/edit_relation(.:format)' => "report_types#edit_relation", :via => :get
    match '/report_types/:id/update_relation(.:format)' => "report_types#update_relation", :via => :put
    match '/report_types/new(.:format)' => "report_types#new", :via => [:get, :post, :put]
    match '/report_types/create(.:format)' => "report_types#create", :via => :post
    match '/report_types/get_data(.:format)' => "report_types#get_data"
    match '/report_types/:id(.:format)' => "report_types#show", :via => :get
    match '/report_types/:id/multilingual_edit(.:format)' => "report_types#multilingual_edit", :via => :get
    match '/report_types/:id/multilingual_update(.:format)' => "report_types#multilingual_update", :via => :put
    # report type sections
    match '/report_type_sections/:report_type_id(/index)(.:format)' => "report_type_sections#index", :via => :get
    match '/report_type_sections/:report_type_id/update(.:format)' => "report_type_sections#update", :via => :post
    match '/report_type_sections/:report_type_id/field_source(.:format)' => "report_type_sections#field_source", :via => :get
    match '/report_type_sections/:report_type_id/section_field(.:format)' => "report_type_sections#section_field", :via => :get

    match '/demo(/index)' => 'demo#index'
    match '/demo/get_data(/index)' => 'demo#get_data'

    #kanbans
    match '/kanbans(/index)(.:format)' => "kanbans#index", :via => :get
    match '/kanbans/:id/show(.:format)' => "kanbans#show", :via => :get
    match '/kanbans/get_data(.:format)' => "kanbans#get_data"
    match '/kanbans/new(.:format)' => "kanbans#new", :via => :get
    match '/kanbans/create(.:format)' => "kanbans#create", :via => :post
    match '/kanbans/:id/edit(.:format)' => "kanbans#edit", :via => :get
    match '/kanbans/:id/update(.:format)' => "kanbans#update", :via => :put
    match '/kanbans/:id/get_available_lanes(.:format)' => "kanbans#get_available_lanes", :via => :get
    match '/kanbans/:id/get_owned_lanes(.:format)' => "kanbans#get_owned_lanes", :via => :get
    match '/kanbans/:id/add_lanes(.:format)' => "kanbans#add_lanes", :via => :post
    match '/kanbans/:id/select_lanes(.:format)' => "kanbans#select_lanes", :via => :get
    match '/kanbans/:kanban_id/:lane_id/delete_lane(.:format)' => "kanbans#delete_lane"
    match '/kanbans/:position_code/refresh_my_kanban/:mode(.:format)' => "kanbans#refresh_my_kanban"
    match '/kanbans/:kanban_id/:lane_id/up_lane(.:format)' => "kanbans#up_lane", :via => :get
    match '/kanbans/:kanban_id/:lane_id/down_lane(.:format)' => "kanbans#down_lane", :via => :get

    match '/kanbans/:id/multilingual_edit(.:format)' => "kanbans#multilingual_edit", :via => :get
    match '/kanbans/:id/multilingual_update(.:format)' => "kanbans#multilingual_update", :via => :put
    #lanes
    match '/lanes(/index)(.:format)' => "lanes#index", :via => :get
    match '/lanes/:id/show(.:format)' => "lanes#show", :via => :get
    match '/lanes/get_data(.:format)' => "lanes#get_data"
    match '/lanes/new(.:format)' => "lanes#new", :via => :get
    match '/lanes/create(.:format)' => "lanes#create", :via => :post
    match '/lanes/:id/edit(.:format)' => "lanes#edit", :via => :get
    match '/lanes/:id/update(.:format)' => "lanes#update", :via => :put

    match '/lanes/:id/select_cards(.:format)' => "lanes#select_cards", :via => :get
    match '/lanes/:lane_id/:card_id/delete_card(.:format)' => "lanes#delete_card"
    match '/lanes/:id/get_owned_cards(.:format)' => "lanes#get_owned_cards", :via => :get
    match '/lanes/:id/add_cards(.:format)' => "lanes#add_cards", :via => :post
    match '/lanes/:id/get_available_cards(.:format)' => "lanes#get_available_cards", :via => :get
    match '/lanes/:id/multilingual_edit(.:format)' => "lanes#multilingual_edit", :via => :get
    match '/lanes/:id/multilingual_update(.:format)' => "lanes#multilingual_update", :via => :put

    #cards
    match '/cards(/index)(.:format)' => "cards#index", :via => :get
    match '/cards/:id/show(.:format)' => "cards#show", :via => :get
    match '/cards/get_data(.:format)' => "cards#get_data"
    match '/cards/new(.:format)' => "cards#new", :via => [:get, :post, :put]
    match '/cards/create(.:format)' => "cards#create", :via => :post
    match '/cards/:id/edit(.:format)' => "cards#edit", :via => :get
    match '/cards/:id/update(.:format)' => "cards#update", :via => :put
    match '/cards/:id/edit_rule(.:format)' => "cards#edit_rule", :via => :get
    match '/cards/:id/update_rule(.:format)' => "cards#update_rule", :via => :put
    match '/cards/:id/multilingual_edit(.:format)' => "cards#multilingual_edit", :via => :get
    match '/cards/:id/multilingual_update(.:format)' => "cards#multilingual_update", :via => :put

    #tabs
    match '/tabs(/index)(.:format)' => "tabs#index", :via => :get
    match '/tabs/:id/edit(.:format)' => "tabs#edit", :via => :get
    match '/tabs/:id(.:format)' => "tabs#update", :via => :put
    match '/tabs/new(.:format)' => "tabs#new", :via => :get
    match '/tabs/create(.:format)' => "tabs#create", :via => :post
    match '/tabs/:id/multilingual_edit(.:format)' => "tabs#multilingual_edit", :via => :get
    match '/tabs/:id/multilingual_update(.:format)' => "tabs#multilingual_update", :via => :put
    match '/tabs/get_data(.:format)' => "tabs#get_data"
    match '/tabs/:id/show(.:format)' => "tabs#show", :via => :get
    #applications
    match '/applications(/index)(.:format)' => "applications#index", :via => :get
    match '/applications/:id/edit(.:format)' => "applications#edit", :via => :get
    match '/applications/:id(.:format)' => "applications#update", :via => :put
    match '/applications/new(.:format)' => "applications#new", :via => :get
    match '/applications/create(.:format)' => "applications#create", :via => :post
    match '/applications/:id/multilingual_edit(.:format)' => "applications#multilingual_edit", :via => :get
    match '/applications/:id/multilingual_update(.:format)' => "applications#multilingual_update", :via => :put
    match '/applications/get_data(.:format)' => "applications#get_data"
    match '/applications/:id/show(.:format)' => "applications#show", :via => :get

    #profiles
    match '/profiles(/index)(.:format)' => "profiles#index", :via => :get
    match '/profiles/:id/edit(.:format)' => "profiles#edit", :via => :get
    match '/profiles/:id(.:format)' => "profiles#update", :via => :put
    match '/profiles/new(.:format)' => "profiles#new", :via => :get
    match '/profiles/create(.:format)' => "profiles#create", :via => :post
    match '/profiles/:id/multilingual_edit(.:format)' => "profiles#multilingual_edit", :via => :get
    match '/profiles/:id/multilingual_update(.:format)' => "profiles#multilingual_update", :via => :put
    match '/profiles/get_data(.:format)' => "profiles#get_data"
    match '/profiles/:id/show(.:format)' => "profiles#show", :via => :get

    #password policies
    match '/password_policies(/index)(.:format)' => "password_policies#index", :via => :get
    match '/password_policies/:id(.:format)' => "password_policies#update", :via => :put

    #session settings
    match '/session_settings(/index)(.:format)' => "session_settings#index", :via => :get
    match '/session_settings/:id(.:format)' => "session_settings#update", :via => :put
    match '/session_settings/timeout_warn(.:format)' => "session_settings#timeout_warn", :via => :get

    #operation unit
    match '/operation_units(/show)(.:format)' => "operation_units#show", :via => :get
    match '/operation_units/edit(.:format)' => "operation_units#edit", :via => :get
    match '/operation_units/update(.:format)' => "operation_units#update", :via => :put

    #cloud_operations
    match '/cloud_operations(/index)(.:format)' => "cloud_operations#index", :via => :get
    match '/cloud_operations/:id/edit(.:format)' => "cloud_operations#edit", :via => :get
    match '/cloud_operations/:id(.:format)' => "cloud_operations#update", :via => :put
    #match '/cloud_operations/new(.:format)' => "cloud_operations#new", :via => :get
    #match '/cloud_operations/create(.:format)' => "cloud_operations#create", :via => :post
    match '/cloud_operations/get_data(.:format)' => "cloud_operations#get_data"
    match '/cloud_operations/:id/show(.:format)' => "cloud_operations#show", :via => :get

    #external_systems
    match '/external_systems(/index)(.:format)' => "external_systems#index", :via => :get
    match '/external_systems/get_data(.:format)' => "external_systems#get_data"
    match '/external_systems/:id/edit(.:format)' => "external_systems#edit", :via => :get
    match '/external_systems/:id(.:format)' => "external_systems#update", :via => :put
    match '/external_systems/new(.:format)' => "external_systems#new", :via => :get
    match '/external_systems/:id(.:format)' => "external_systems#show", :via => :get
    match '/external_systems/create(.:format)' => "external_systems#create", :via => :post
    match '/external_systems/:id/multilingual_edit(.:format)' => "external_systems#multilingual_edit", :via => :get
    match '/external_systems/:id/multilingual_update(.:format)' => "external_systems#multilingual_update", :via => :put

    match '/external_systems/:external_system_id/add_people(.:format)' => "external_systems#add_people"
    match '/external_systems/:external_system_id/delete_people(.:format)' => "external_systems#delete_people"

    #external_system_person
    match '/external_system_members(/index)(.:format)' => "external_system_members#index", :via => :get
    match '/external_system_members/:external_system_id/get_owned_members_data(.:format)' => "external_system_members#get_owned_members_data", :via => :get
    match '/external_system_members/:external_system_id/add_people(.:format)' => "external_system_members#add_people"
    match '/external_system_members/:external_system_id/get_available_people_data(.:format)' => "external_system_members#get_available_people_data"
    match '/external_system_members/:external_system_id/delete_people(.:format)' => "external_system_members#delete_people"

    match '/external_system_members/:person_id/new_from_person(.:format)' => "external_system_members#new_from_person", :via => :get
    match '/external_system_members/:person_id/create_from_person(.:format)' => "external_system_members#create_from_person", :via => :post
    match '/external_system_members/:person_id/delete_from_person(.:format)' => "external_system_members#delete_from_person"
    match '/external_system_members/:person_id/get_available_external_system_data(.:format)' => "external_system_members#get_available_external_system_data", :via => :get


    #licenses
    match '/licenses(/index)(.:format)' => "licenses#index", :via => :get
    match '/licenses/:id/edit(.:format)' => "licenses#edit", :via => :get
    match '/licenses/:id(.:format)' => "licenses#update", :via => :put
    match '/licenses/new(.:format)' => "licenses#new", :via => :get
    match '/licenses/create(.:format)' => "licenses#create", :via => :post
    match '/licenses/:id/multilingual_edit(.:format)' => "licenses#multilingual_edit", :via => :get
    match '/licenses/:id/multilingual_update(.:format)' => "licenses#multilingual_update", :via => :put
    match '/licenses/get_data(.:format)' => "licenses#get_data"
    match '/licenses/:id/show(.:format)' => "licenses#show", :via => :get

    #mail_settings
    match '/mail_settings(/index)(.:format)' => "mail_settings#index", :via => :get
    match '/mail_settings/edit(.:format)' => "mail_settings#edit", :via => :get
    match '/mail_settings/update(.:format)' => "mail_settings#update", :via => :post

    #portlet_config
    match '/portlet_configs(/index)(.:format)' => "portlet_configs#index", :via => :get
    match '/portlet_configs/:id/show(.:format)' => "portlet_configs#show", :via => :get
    match '/portlet_configs/:id/edit(.:format)' => "portlet_configs#edit", :via => :get
    match '/portlet_configs/:id(.:format)' => "portlet_configs#update", :via => :put
    match '/portlet_configs/new(.:format)' => "portlet_configs#new", :via => :get
    match '/portlet_configs/create(.:format)' => "portlet_configs#create", :via => :post
    match '/portlet_configs/get_data(.:format)' => "portlet_configs#get_data"
    match '/portlet_configs/:id/destroy(.:format)' => "portlet_configs#destroy", :via => :delete
    match '/portlet_configs/get_data(.:format)' => "portlet_configs#get_data"
    match '/portlet_configs/save_portal_config(.:format)' => "portlet_configs#save_portal_config", :via => :post
    match '/portlet_configs/save_portal_layout(.:format)' => "portlet_configs#save_portal_layout", :via => :post

    #portlets
    match '/portlets(/index)(.:format)' => "portlets#index", :via => :get
    match '/portlets/new(.:format)' => "portlets#new", :via => :get
    match '/portlets/:id/edit(.:format)' => "portlets#edit", :via => :get
    match '/portlets/create(.:format)' => "portlets#create", :via => :post
    match '/portlets/:id(.:format)' => "portlets#update", :via => :put
    match '/portlets/:id/show(.:format)' => "portlets#show", :via => :get
    match '/portlets/get_data(.:format)' => "portlets#get_data"
    match '/portlets/:id/destroy(.:format)' => "portlets#destroy", :via => :delete
    match '/portlets/:id/multilingual_edit(.:format)' => "portlets#multilingual_edit", :via => :get
    match '/portlets/:id/multilingual_update(.:format)' => "portlets#multilingual_update", :via => :put
    match '/portlets/get_actions_options(.:format)' => "portlets#get_actions_options"


    #portal_layouts
    match '/portal_layouts(/index)(.:format)' => "portal_layouts#index", :via => :get
    match '/portal_layouts/new(.:format)' => "portal_layouts#new", :via => :get
    match '/portal_layouts/:id/edit(.:format)' => "portal_layouts#edit", :via => :get
    match '/portal_layouts/create(.:format)' => "portal_layouts#create", :via => :post
    match '/portal_layouts/:id(.:format)' => "portal_layouts#update", :via => :put
    match '/portal_layouts/:id/show(.:format)' => "portal_layouts#show", :via => :get
    match '/portal_layouts/get_data(.:format)' => "portal_layouts#get_data"
    match '/portal_layouts/:id/destroy(.:format)' => "portal_layouts#destroy", :via => :delete
    match '/portal_layouts/:id/multilingual_edit(.:format)' => "portal_layouts#multilingual_edit", :via => :get
    match '/portal_layouts/:id/multilingual_update(.:format)' => "portal_layouts#multilingual_update", :via => :put

    # data accesses
    match '/data_accesses(/index)(.:format)' => "data_accesses#index", :via => :get
    match '/data_accesses/edit(.:format)' => "data_accesses#edit", :via => :get
    match '/data_accesses/update(.:format)' => "data_accesses#update", :via => :post

    # org data accesses
    match '/org_data_accesses(/index)(.:format)' => "org_data_accesses#index", :via => :get
    match '/org_data_accesses/:id/edit(.:format)' => "org_data_accesses#edit", :via => :get
    match '/org_data_accesses/:id/update(.:format)' => "org_data_accesses#update", :via => :post
    match '/org_data_accesses/:id/show(.:format)' => "org_data_accesses#show", :via => :get

    #data_share_rules
    match '/data_share_rules(/index)(.:format)' => "data_share_rules#index", :via => :get
    match '/data_share_rules/:business_object_id/new(.:format)' => "data_share_rules#new", :via => :get
    match '/data_share_rules/get_option(.:format)' => "data_share_rules#get_option", :via => :get
    match '/data_share_rules/:id/edit(.:format)' => "data_share_rules#edit", :via => :get
    match '/data_share_rules/:business_object_id/create(.:format)' => "data_share_rules#create", :via => :post
    match '/data_share_rules/:id/update(.:format)' => "data_share_rules#update", :via => :put
    match '/data_share_rules/:id/show(.:format)' => "data_share_rules#show", :via => :get
    match '/data_share_rules/get_data(.:format)' => "data_share_rules#get_data"
    match '/data_share_rules/:id/multilingual_edit(.:format)' => "data_share_rules#multilingual_edit", :via => :get
    match '/data_share_rules/:id/multilingual_update(.:format)' => "data_share_rules#multilingual_update", :via => :put
    match '/data_share_rules/:id/destroy(.:format)' => "data_share_rules#destroy", :via => :delete

    #oauth_access_clients
    match '/oauth_access_clients(/index)(.:format)' => "oauth_access_clients#index", :via => :get
    match '/oauth_access_clients/new(.:format)' => "oauth_access_clients#new", :via => :get
    match '/oauth_access_clients/:id/edit(.:format)' => "oauth_access_clients#edit", :via => :get
    match '/oauth_access_clients/create(.:format)' => "oauth_access_clients#create", :via => :post
    match '/oauth_access_clients/:id/update(.:format)' => "oauth_access_clients#update", :via => :put
    match '/oauth_access_clients/:id/show(.:format)' => "oauth_access_clients#show", :via => :get
    match '/oauth_access_clients/get_data(.:format)' => "oauth_access_clients#get_data"
    match '/oauth_access_clients/:id/destroy(.:format)' => "oauth_access_clients#destroy", :via => :delete

    #oauth_authorize
    get '/oauth/authorize' => "oauth_authorize#show", defaults: {format: "html"}
    post '/oauth/authorize' => "oauth_authorize#create", defaults: {format: "html"}
    post '/oauth/token' => "oauth_authorize#token", defaults: {format: "json"}

    match '/ratings/:rating_object_id/create(.:format)' => "ratings#create", :via => :get

    match '/attachments/:source_id/destroy_attachment/:id(.:format)' => "attachments#destroy_attachment", :via => :delete
    match '/attachments/create_attachment(.:format)' => "attachments#create_attachment", :via => :post
  end
end