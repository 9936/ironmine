Rails.application.routes.draw do
  namespace :isp do
    #config_relation_types
    match '/programs(/index)(.:format)' => "programs#index", :via => :get
    match '/programs/get_data(.:format)' => "programs#get_data"
    match '/programs/:id/edit(.:format)' => "programs#edit", :via => :get
    match '/programs/:id(.:format)' => "programs#update", :via => :put
    match '/programs/new(.:format)' => "programs#new", :via => :get
    match '/programs/:id(.:format)' => "programs#show", :via => :get
    match '/programs/create(.:format)' => "programs#create", :via => :post
    match '/programs/:id/multilingual_edit(.:format)' => "programs#multilingual_edit", :via => :get
    match '/programs/:id/multilingual_update(.:format)' => "programs#multilingual_update", :via => :put
  end

  #namespace :isp do
  #
  #  resources :check_parameters
  #
  #  resources :check_items
  #  resources :programs
  #end
end