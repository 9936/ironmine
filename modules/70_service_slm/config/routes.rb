Ironmine::Application.routes.draw do


  #service catalog and service level agreement(slm)
  scope :module => "slm" do
    #service categories
    match '/service_categories(/index)(.:format)' => "service_categories#index", :via => :get
    match '/service_categories/get_data(.:format)' => "service_categories#get_data"
    match '/service_categories/:id/edit(.:format)' => "service_categories#edit", :via => :get
    match '/service_categories/:id(.:format)' => "service_categories#update", :via => :put
    match '/service_categories/new(.:format)' => "service_categories#new", :via => :get
    match '/service_categories/:id(.:format)' => "service_categories#show", :via => :get
    match '/service_categories/create(.:format)' => "service_categories#create", :via => :post
    match '/service_categories/:id/multilingual_edit(.:format)' => "service_categories#multilingual_edit", :via => :get
    match '/service_categories/:id/multilingual_update(.:format)' => "service_categories#multilingual_update", :via => :put
    #service catalogs
    match '/service_catalogs(/index)(.:format)' => "service_catalogs#index", :via => :get
    match '/service_catalogs/get_data(.:format)' => "service_catalogs#get_data"
    match '/service_catalogs/:id/edit(.:format)' => "service_catalogs#edit", :via => :get
    match '/service_catalogs/:id(.:format)' => "service_catalogs#update", :via => :put
    match '/service_catalogs/new(.:format)' => "service_catalogs#new", :via => :get
    match '/service_catalogs/:id(.:format)' => "service_catalogs#show", :via => :get
    match '/service_catalogs/create(.:format)' => "service_catalogs#create", :via => :post
    match '/service_catalogs/:id/multilingual_edit(.:format)' => "service_catalogs#multilingual_edit", :via => :get
    match '/service_catalogs/:id/multilingual_update(.:format)' => "service_catalogs#multilingual_update", :via => :put
    #service_members
    match '/service_catalogs/:service_catalog_id/service_members(/index)(.:format)' => "service_members#index", :via => :get
    match '/service_catalogs/:service_catalog_id/service_members/get_data(.:format)' => "service_members#get_data"
    match '/service_catalogs/:service_catalog_id/service_members/:id/edit(.:format)' => "service_members#edit", :via => :get
    match '/service_catalogs/:service_catalog_id/service_members/:id(.:format)' => "service_members#update", :via => :put
    match '/service_catalogs/:service_catalog_id/service_members/new(.:format)' => "service_members#new", :via => :get
    match '/service_catalogs/:service_catalog_id/service_members/create(.:format)' => "service_members#create", :via => :post
    match '/service_catalogs/:service_catalog_id/service_members/:id(.:format)' => "service_members#destroy", :via => :delete
    match '/service_catalogs/:service_catalog_id/service_members/:id(.:format)' => "service_members#show", :via => :get
    #service_breaks
    match '/service_catalogs/:service_catalog_id/service_breaks(/index)(.:format)' => "service_breaks#index", :via => :get
    match '/service_catalogs/:service_catalog_id/service_breaks/get_data(.:format)' => "service_breaks#get_data"
    match '/service_catalogs/:service_catalog_id/service_breaks/:id/edit(.:format)' => "service_breaks#edit", :via => :get
    match '/service_catalogs/:service_catalog_id/service_breaks/:id(.:format)' => "service_breaks#update", :via => :put
    match '/service_catalogs/:service_catalog_id/service_breaks/new(.:format)' => "service_breaks#new", :via => :get
    match '/service_catalogs/:service_catalog_id/service_breaks/create(.:format)' => "service_breaks#create", :via => :post
    match '/service_catalogs/:service_catalog_id/service_breaks/:id(.:format)' => "service_breaks#destroy", :via => :delete
    match '/service_catalogs/:service_catalog_id/service_breaks/:id(.:format)' => "service_breaks#show", :via => :get
    #service_agreements
    scope "/:sid" do
      match '/service_agreements(/index)(.:format)' => "service_agreements#index", :via => :get
      match '/service_agreements/get_data(.:format)' => "service_agreements#get_data"
      match '/service_agreements/add_response_time_rule(.:format)' => "service_agreements#add_response_time_rule"
      match '/service_agreements/add_solve_time_rule(.:format)' => "service_agreements#add_solve_time_rule"
      match '/service_agreements/get_by_assignee_type(.:format)' => "service_agreements#get_by_assignee_type"
      match '/service_agreements/:id/edit(.:format)' => "service_agreements#edit", :via => :get
      match '/service_agreements/:id(.:format)' => "service_agreements#update", :via => :put
      match '/service_agreements/new(.:format)' => "service_agreements#new", :via => :get
      match '/service_agreements/:id(.:format)' => "service_agreements#show", :via => :get
      match '/service_agreements/create(.:format)' => "service_agreements#create", :via => :post
      match '/service_agreements/:id/multilingual_edit(.:format)' => "service_agreements#multilingual_edit", :via => :get
      match '/service_agreements/:id/multilingual_update(.:format)' => "service_agreements#multilingual_update", :via => :put
      match '/service_agreements/:id/match_filter_edit(.:format)' => "service_agreements#match_filter_edit", :via => :get
      match '/service_agreements/:id/match_filter_update(.:format)' => "service_agreements#match_filter_update", :via => :put
      match '/service_agreements/add_exists_action/:id(.:format)' => "service_agreements#add_exists_action"
      match '/service_agreements/:id/save_exists_action(.:format)' => "service_agreements#save_exists_action", :via => :post
      match '/service_agreements/:id/destroy_action(.:format)' => "service_agreements#destroy_action"
      match '/service_agreements/:bo_id/show_relations(.:format)' => "service_agreements#show_relations"


      # service_agreements time_triggers
      match '/service_agreements/:service_agreement_id/time_triggers/new(.:format)' => "time_triggers#new", :via => :get
      match '/service_agreements/:service_agreement_id/time_triggers/create(.:format)' => "time_triggers#create", :via => :post
      match '/service_agreements/:service_agreement_id/time_triggers/:id/edit(.:format)' => "time_triggers#edit", :via => :get
      match '/service_agreements/:service_agreement_id/time_triggers/:id(.:format)' => "time_triggers#update", :via => :put
      match '/service_agreements/:service_agreement_id/time_triggers/:id/destroy(.:format)' => "time_triggers#destroy"
    end

    #calendars
    match '/calendars/:sid(/index)(.:format)' => "calendars#index", :via => :get
    match '/calendars/:sid/get_data(.:format)' => "calendars#get_data"
    match '/calendars/:sid/:id/edit(.:format)' => "calendars#edit", :via => :get
    match '/calendars/:sid/:id(.:format)' => "calendars#update", :via => :put
    match '/calendars/:sid/new(.:format)' => "calendars#new", :via => :get
    match '/calendars/:sid/:id(.:format)' => "calendars#show", :via => :get
    match '/calendars/:sid/:id/schedule_events(.:format)' => "calendars#schedule_events", :via => :get
    match '/calendars/:sid/create(.:format)' => "calendars#create", :via => :post
    match '/calendars/:sid/:id/multilingual_edit(.:format)' => "calendars#multilingual_edit", :via => :get
    match '/calendars/:sid/:id/multilingual_update(.:format)' => "calendars#multilingual_update", :via => :put

    #calendar items
    #match '/calendars/:sid/:calendar_id/calendar_items/get_data(.:format)' => "calendar_items#get_data"
    match '/calendars/:sid/:calendar_id/calendar_items/:id/edit(.:format)' => "calendar_items#edit", :via => :get
    match '/calendars/:sid/:calendar_id/calendar_items/:id(.:format)' => "calendar_items#update"
    match '/calendars/:sid/:calendar_id/calendar_items/new(.:format)' => "calendar_items#new", :via => :get
    match '/calendars/:sid/:calendar_id/calendar_items/:id(.:format)' => "calendar_items#show", :via => :get
    match '/calendars/:sid/:calendar_id/calendar_items/:id/destroy(.:format)' => "calendar_items#destroy"
    match '/calendars/:sid/:calendar_id/calendar_items/create(.:format)' => "calendar_items#create", :via => :post
    #match '/calendars/:sid/:calendar_id/calendar_items/:id/multilingual_edit(.:format)' => "calendar_items#multilingual_edit", :via => :get
    #match '/calendars/:sid/:calendar_id/calendar_items/:id/multilingual_update(.:format)' => "calendar_items#multilingual_update", :via => :put

  end

end
