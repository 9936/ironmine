Rails.application.routes.draw do
  namespace :isp do
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

    #connections
    match '/programs/:program_id/connections/get_data(.:format)' => "connections#get_data"
    match '/programs/:program_id/connections/:id/edit(.:format)' => "connections#edit", :via => :get
    match '/programs/:program_id/connections/:id(.:format)' => "connections#update", :via => :put
    match '/programs/:program_id/connections/new(.:format)' => "connections#new", :via => :get
    match '/programs/:program_id/connections/:id(.:format)' => "connections#show", :via => :get
    match '/programs/:program_id/connections/:id/destroy(.:format)' => "connections#destroy", :via => :delete
    match '/programs/:program_id/connections/create(.:format)' => "connections#create", :via => :post
  end

  #namespace :isp do
  #
  #  resources :check_parameters
  #
  #  resources :check_items
  #  resources :programs
  #end
end