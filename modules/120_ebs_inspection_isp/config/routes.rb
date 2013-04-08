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

    #check_parameters
    match '/programs/:program_id/check_parameters/get_data(.:format)' => "check_parameters#get_data"
    match '/programs/:program_id/check_parameters/:id/edit(.:format)' => "check_parameters#edit", :via => :get
    match '/programs/:program_id/check_parameters/:id(.:format)' => "check_parameters#update", :via => :put
    match '/programs/:program_id/check_parameters/new(.:format)' => "check_parameters#new", :via => :get
    match '/programs/:program_id/check_parameters/:id(.:format)' => "check_parameters#show", :via => :get
    match '/programs/:program_id/check_parameters/:id/destroy(.:format)' => "check_parameters#destroy", :via => :delete
    match '/programs/:program_id/check_parameters/create(.:format)' => "check_parameters#create", :via => :post

    #check_items
    match '/programs/:program_id/check_items/get_data(.:format)' => "check_items#get_data"
    match '/programs/:program_id/check_items/:id/edit(.:format)' => "check_items#edit", :via => :get
    match '/programs/:program_id/check_items/:id(.:format)' => "check_items#update", :via => :put
    match '/programs/:program_id/check_items/new(.:format)' => "check_items#new", :via => :get
    match '/programs/:program_id/check_items/:id(.:format)' => "check_items#show", :via => :get
    match '/programs/:program_id/check_items/:id/destroy(.:format)' => "check_items#destroy", :via => :delete
    match '/programs/:program_id/check_items/create(.:format)' => "check_items#create", :via => :post
  end

  #namespace :isp do
  #
  #  resources :check_check_parameters
  #
  #  resources :check_items
  #  resources :programs
  #end
end