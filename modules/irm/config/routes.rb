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

    #wikis
    match '/wikis(/index)(.:format)' => "wikis#index", :via => :get
    match '/wikis/:id/edit(.:format)' => "wikis#edit", :via => :get
    match '/wikis/:id(.:format)' => "wikis#update", :via => :put
    match '/wikis/new(.:format)' => "wikis#new", :via => :get
    match '/wikis/get_data(.:format)' => "wikis#get_data", :via => :get
    match '/wikis/create(.:format)' => "wikis#create", :via => :post
    match '/wikis/get_data(.:format)' => "wikis#get_data"
    match '/wikis/:id/show(.:format)' => "wikis#show", :via => :get
    match '/wikis/:id/preview(.:format)' => "wikis#preview", :via => [:post,:put]
    match '/wikis/:id/history(.:format)' => "wikis#history", :via => :get
    match '/wikis/:id/compare(.:format)' => "wikis#compare", :via => [:get,:post]
    match '/wikis/:id/revert(.:format)' => "wikis#revert", :via => [:post]
  end
end