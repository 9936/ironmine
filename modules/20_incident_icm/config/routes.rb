Ironmine::Application.routes.draw do

 scope :module => "icm" do
    match '/rule_settings(/index)(.:format)' => "rule_settings#index", :via => :get
    match '/rule_settings/:id/edit(.:format)' => "rule_settings#edit", :via => :get
    match '/rule_settings/:id(.:format)' => "rule_settings#update", :via => :put
    match '/rule_settings/new(.:format)' => "rule_settings#new", :via => :get
    match '/rule_settings/create(.:format)' => "rule_settings#create", :via => :post
    match '/rule_settings/get_data(.:format)' => "rule_settings#get_data"
    match '/rule_settings/:id(.:format)' => "rule_settings#show", :via => :get
    #impact_ranges
    match '/impact_ranges(/index)(.:format)' => "impact_ranges#index", :via => :get
    match '/impact_ranges/:id/edit(.:format)' => "impact_ranges#edit", :via => :get
    match '/impact_ranges/:id(.:format)' => "impact_ranges#update", :via => :put
    match '/impact_ranges/new(.:format)' => "impact_ranges#new", :via => :get
    match '/impact_ranges/create(.:format)' => "impact_ranges#create", :via => :post
    match '/impact_ranges/get_data(.:format)' => "impact_ranges#get_data"
    match '/impact_ranges/:id/show(.:format)' => "impact_ranges#show", :via => :get
    match '/impact_ranges/:id/multilingual_edit(.:format)' => "impact_ranges#multilingual_edit", :via => :get
    match '/impact_ranges/:id/multilingual_update(.:format)' => "impact_ranges#multilingual_update", :via => :put    
    #urgence_codes
    match '/urgence_codes(/index)(.:format)' => "urgence_codes#index", :via => :get
    match '/urgence_codes/:id/edit(.:format)' => "urgence_codes#edit", :via => :get
    match '/urgence_codes/:id(.:format)' => "urgence_codes#update", :via => :put
    match '/urgence_codes/new(.:format)' => "urgence_codes#new", :via => :get
    match '/urgence_codes/create(.:format)' => "urgence_codes#create", :via => :post
    match '/urgence_codes/:id/multilingual_edit(.:format)' => "urgence_codes#multilingual_edit", :via => :get
    match '/urgence_codes/:id/multilingual_update(.:format)' => "urgence_codes#multilingual_update", :via => :put
    match '/urgence_codes/get_data(.:format)' => "urgence_codes#get_data"
    match '/urgence_codes/:id(.:format)' => "urgence_codes#show" ,:via=>:get
    #priority_codes
    match '/priority_codes(/index)(.:format)' => "priority_codes#index", :via => :get
    match '/priority_codes/:id/edit(.:format)' => "priority_codes#edit", :via => :get
    match '/priority_codes/:id(.:format)' => "priority_codes#update", :via => :put
    match '/priority_codes/new(.:format)' => "priority_codes#new", :via => :get
    match '/priority_codes/create(.:format)' => "priority_codes#create", :via => :post
    match '/priority_codes/:id/multilingual_edit(.:format)' => "priority_codes#multilingual_edit", :via => :get
    match '/priority_codes/:id/multilingual_update(.:format)' => "priority_codes#multilingual_update", :via => :put
    match '/priority_codes/get_data(.:format)' => "priority_codes#get_data"
    match '/priority_codes/:id(.:format)' => "priority_codes#show", :via => :get
    #close_reasons
    match '/close_reasons(/index)(.:format)' => "close_reasons#index", :via => :get
    match '/close_reasons/:id/edit(.:format)' => "close_reasons#edit", :via => :get
    match '/close_reasons/:id(.:format)' => "close_reasons#update", :via => :put
    match '/close_reasons/new(.:format)' => "close_reasons#new", :via => :get
    match '/close_reasons/create(.:format)' => "close_reasons#create", :via => :post
    match '/close_reasons/:id/show(.:format)' => "close_reasons#show", :via => :get
    match '/close_reasons/get_data(.:format)' => "close_reasons#get_data"
    match '/close_reasons/:id/multilingual_edit(.:format)' => "close_reasons#multilingual_edit", :via => :get
    match '/close_reasons/:id/multilingual_update(.:format)' => "close_reasons#multilingual_update", :via => :put

    #incident_phases
    match '/incident_phases(/index)(.:format)' => "incident_phases#index", :via => :get
    match '/incident_phases/:id/edit(.:format)' => "incident_phases#edit", :via => :get
    match '/incident_phases/:id(.:format)' => "incident_phases#update", :via => :put
    match '/incident_phases/new(.:format)' => "incident_phases#new", :via => :get
    match '/incident_phases/create(.:format)' => "incident_phases#create", :via => :post
    match '/incident_phases/get_data(.:format)' => "incident_phases#get_data"
    match '/incident_phases/:id/show(.:format)' => "incident_phases#show", :via => :get
    match '/incident_phases/:id/multilingual_edit(.:format)' => "incident_phases#multilingual_edit", :via => :get
    match '/incident_phases/:id/multilingual_update(.:format)' => "incident_phases#multilingual_update", :via => :put    
    #incident_statuses
    match '/incident_statuses(/index)(.:format)' => "incident_statuses#index", :via => :get
    match '/incident_statuses/:id/edit(.:format)' => "incident_statuses#edit", :via => :get
    match '/incident_statuses/:id(.:format)' => "incident_statuses#update", :via => :put
    match '/incident_statuses/new(.:format)' => "incident_statuses#new", :via => :get
    match '/incident_statuses/create(.:format)' => "incident_statuses#create", :via => :post
    match '/incident_statuses/:id/multilingual_edit(.:format)' => "incident_statuses#multilingual_edit", :via => :get
    match '/incident_statuses/:id/multilingual_update(.:format)' => "incident_statuses#multilingual_update", :via => :put
    match '/incident_statuses/get_data(.:format)' => "incident_statuses#get_data"
    match '/incident_statuses/:id/show(.:format)' => "incident_statuses#show", :via => :get
    match '/incident_statuses/edit_transform(.:format)' => "incident_statuses#edit_transform", :via => :get
    match '/incident_statuses/update_transform(.:format)' => "incident_statuses#update_transform", :via => :post


    #incident_requests
    match '/incident_requests/get_external_systems(.:format)' => "incident_requests#get_external_systems", :via => :get
    match '/incident_requests/get_slm_services(.:format)' => "incident_requests#get_slm_services", :via => :get
    match '/incident_requests/get_all_slm_services(.:format)' => "incident_requests#get_all_slm_services", :via => :get
    match '/incident_requests(/index)(.:format)' => "incident_requests#index", :via => :get
    match '/incident_requests/:id/edit(.:format)' => "incident_requests#edit", :via => :get
    match '/incident_requests/:id(.:format)' => "incident_requests#update", :via => :put
    match '/incident_requests/new(.:format)' => "incident_requests#new", :via => [:get,:post]
    match '/incident_requests/create(.:format)' => "incident_requests#create", :via => :post
    match '/incident_requests/get_data(.:format)' => "incident_requests#get_data",:via=>:get
    match '/incident_requests/get_help_desk_data(.:format)' => "incident_requests#get_help_desk_data",:via=>:get
    match '/incident_requests/short_create(.:format)' => "incident_requests#short_create", :via => :post
    match '/incident_requests/assign_dashboard(.:format)' => "incident_requests#assign_dashboard", :via => :get
    match '/incident_requests/assignable_data(.:format)' => "incident_requests#assignable_data", :via => :get
    match '/incident_requests/assign_request(.:format)' => "incident_requests#assign_request", :via => :post
    match '/incident_requests/kanban_index(.:format)' => "incident_requests#kanban_index", :via => :get
    match '/incident_requests/edit_assign_me(.:format)' => "incident_requests#edit_assign_me", :via => :get
    match '/incident_requests/update_assign_me(.:format)' => "incident_requests#update_assign_me", :via => [:post ,:get]
    match '/incident_requests/assign_me_data(.:format)' => "incident_requests#assign_me_data", :via => :get

    match '/incident_requests/:incident_request_id/:att_id/remove_exists_attachments(.:format)' => "incident_requests#remove_exists_attachments"
    match '/incident_requests/:source_id/add_relation(.:format)' => "incident_requests#add_relation", :via => :post
    match '/incident_requests/remove_relation(.:format)' => "incident_requests#remove_relation"
    match '/incident_requests/:request_id/info_card(.:format)' => "incident_requests#info_card", :via => :get

    #incident_journals
    match '/incident_requests/:request_id/journals(/index)(.:format)' => "incident_journals#index", :via => :get    
    match '/incident_requests/:request_id/journals/edit_close(.:format)' => "incident_journals#edit_close", :via => :get
    match '/incident_requests/:request_id/journals/update_close(.:format)' => "incident_journals#update_close", :via => :put
    match '/incident_requests/:request_id/journals/edit_reopen(.:format)' => "incident_journals#edit_reopen", :via => :get
    match '/incident_requests/:request_id/journals/update_reopen(.:format)' => "incident_journals#update_reopen", :via => :put
    match '/incident_requests/:request_id/journals/edit_permanent_close(.:format)' => "incident_journals#edit_permanent_close", :via => :get
    match '/incident_requests/:request_id/journals/update_permanent_close(.:format)' => "incident_journals#update_permanent_close", :via => :put
    match '/incident_requests/:request_id/journals/edit_pass(.:format)' => "incident_journals#edit_pass", :via => :get
    match '/incident_requests/:request_id/journals/edit_upgrade(.:format)' => "incident_journals#edit_upgrade", :via => :get
    match '/incident_requests/:request_id/journals/update_upgrade(.:format)' => "incident_journals#update_upgrade", :via => :put
    match '/incident_requests/:request_id/journals/update_pass(.:format)' => "incident_journals#update_pass", :via => :put
    match '/incident_requests/:request_id/journals/new(.:format)' => "incident_journals#new", :via => :get
    match '/incident_requests/:request_id/journals/create(.:format)' => "incident_journals#create", :via => :post
    match '/incident_requests/:request_id/journals/get_entry_header_data(.:format)' => "incident_journals#get_entry_header_data", :via => :get
    match '/incident_requests/:request_id/journals/apply_entry_header(.:format)' => "incident_journals#apply_entry_header", :via => :get
    match '/incident_requests/:request_id/journals/apply_entry_header_link(.:format)' => "incident_journals#apply_entry_header_link", :via => :get
    match '/incident_requests/:request_id/journals/edit_status(.:format)' => "incident_journals#edit_status", :via => :get
    match '/incident_requests/:request_id/journals/update_status(.:format)' => "incident_journals#update_status", :via => :put
    match '/incident_requests/:request_id/journals/:id/edit(.:format)' => "incident_journals#edit", :via => :get
    match '/incident_requests/:request_id/journals/:id/update(.:format)' => "incident_journals#update"
    match '/incident_requests/:request_id/journals/:id/delete(.:format)' => "incident_journals#delete"
    match '/incident_requests/:request_id/journals/:id/recover(.:format)' => "incident_journals#recover"
    match '/incident_requests/:request_id/journals/all_journals(.:format)' => "incident_journals#all_journals", :via => :get

    #support_groups
    match '/support_groups/:id/get_member_options(.:format)' => "support_groups#get_member_options", :via => :get
    match '/support_groups/:id/get_pass_member_options(.:format)' => "support_groups#get_pass_member_options", :via => :get
    match '/support_groups(/index)(.:format)' => "support_groups#index", :via => :get
    match '/support_groups/:id/edit(.:format)' => "support_groups#edit", :via => :get
    match '/support_groups/:id(.:format)' => "support_groups#update", :via => :put
    match '/support_groups/new(.:format)' => "support_groups#new", :via => :get
    match '/support_groups/create(.:format)' => "support_groups#create", :via => :post
    match '/support_groups/get_data(.:format)' => "support_groups#get_data"
    match '/support_groups/:id/show(.:format)' => "support_groups#show", :via => :get

    #mail request
    match '/mail_requests(/index)(.:format)' => "mail_requests#index", :via => :get
    match '/mail_requests/new(.:format)' => "mail_requests#new", :via => :get
    match '/mail_requests/create(.:format)' => "mail_requests#create", :via => :post
    match '/mail_requests/edit(.:format)' => "mail_requests#edit", :via => :get
    match '/mail_requests/:id/show(.:format)' => "mail_requests#show", :via => :get
    match '/mail_requests/update(.:format)' => "mail_requests#update", :via => :put
    match '/mail_requests/get_data(.:format)' => "mail_requests#get_data", :via => :get
    match '/mail_requests/enable(.:format)' => "mail_requests#enable", :via => :get
    match '/mail_requests/disable(.:format)' => "mail_requests#disable", :via => :get

    #incident_categories
    match '/incident_categories(/index)(.:format)' => "incident_categories#index", :via => :get
    match '/incident_categories/:id/edit(.:format)' => "incident_categories#edit", :via => :get
    match '/incident_categories/:id(.:format)' => "incident_categories#update", :via => :put
    match '/incident_categories/new(.:format)' => "incident_categories#new", :via => :get
    match '/incident_categories/create(.:format)' => "incident_categories#create", :via => :post
    match '/incident_categories/get_data(.:format)' => "incident_categories#get_data"
    match '/incident_categories/:id/show(.:format)' => "incident_categories#show", :via => :get
    match '/incident_categories/:id/multilingual_edit(.:format)' => "incident_categories#multilingual_edit", :via => :get
    match '/incident_categories/:id/multilingual_update(.:format)' => "incident_categories#multilingual_update", :via => :put
    match '/incident_categories/:external_system_id/get_option(.:format)' => "incident_categories#get_option", :via => :get

    #incident_sub_categories
    match '/incident_sub_categories/:id/edit(.:format)' => "incident_sub_categories#edit", :via => :get
    match '/incident_sub_categories/:id(.:format)' => "incident_sub_categories#update", :via => :put
    match '/incident_sub_categories/:category_id/new(.:format)' => "incident_sub_categories#new", :via => :get
    match '/incident_sub_categories/create(.:format)' => "incident_sub_categories#create", :via => :post
    match '/incident_sub_categories/:id/show(.:format)' => "incident_sub_categories#show", :via => :get
    match '/incident_sub_categories/:id/multilingual_edit(.:format)' => "incident_sub_categories#multilingual_edit", :via => :get
    match '/incident_sub_categories/:id/multilingual_update(.:format)' => "incident_sub_categories#multilingual_update", :via => :put
    match '/incident_sub_categories/:id/destroy(.:format)' => "incident_sub_categories#destroy", :via => :delete
    match '/incident_sub_categories/:incident_category_id/get_option(.:format)' => "incident_sub_categories#get_option", :via => :get

    match '/incident_config_relations/create(.:format)' => "incident_config_relations#create", :via => :post
    match '/incident_config_relations/:id/destroy(.:format)' => "incident_config_relations#destroy", :via => :delete

    #remove attachements
    match '/incident_requests/:attachment_id/remove_attachment(.:format)' => "incident_requests#remove_attachment", :via => :get

    #assign rules
    match '/assign_rules(/index)(.:format)' => "assign_rules#index", :via => :get
    match '/assign_rules/switch_sequence(.:format)' => "assign_rules#switch_sequence"
    match '/assign_rules/:id/edit(.:format)' => "assign_rules#edit", :via => :get
    match '/assign_rules/:id(.:format)' => "assign_rules#update", :via => :put
    match '/assign_rules/new(.:format)' => "assign_rules#new", :via => :get
    match '/assign_rules/create(.:format)' => "assign_rules#create", :via => :post
    match '/assign_rules/get_data(.:format)' => "assign_rules#get_data"
    match '/assign_rules/:id/show(.:format)' => "assign_rules#show", :via => :get
    match '/assign_rules/:id/switch_status_code(.:format)' => "assign_rules#switch_status_code", :via => :get
  end
end
