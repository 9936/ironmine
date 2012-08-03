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
  end

end
