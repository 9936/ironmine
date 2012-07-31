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
end