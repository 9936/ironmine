Rails.application.routes.draw do
  scope :module => "com" do
    #config_classes
    match '/config_classes(/index)(.:format)' => "config_classes#index", :via => :get
    match '/config_classes/new(.:format)'      => "config_classes#new",   :via => :get
    match '/config_classes/:id/edit(.:format)' => "config_classes#edit", :via => :get
    match '/config_classes/create(.:format)'  => "config_classes#create",:via => :post
    match '/config_classes/:id(.:format)'  => "config_classes#update",:via => :put
    match '/config_classes/:id/show(.:format)'=> "config_classes#show",  :via => :get
    match '/config_classes/get_data(.:format)' => "config_classes#get_data"
    match '/config_classes/:id/destroy(.:format)' => "config_classes#destroy", :via => :delete
    match '/config_classes/:id/multilingual_edit(.:format)' => "config_classes#multilingual_edit", :via => :get
    match '/config_classes/:id/multilingual_update(.:format)' => "config_classes#multilingual_update", :via => :put

    #config_attributes
    match '/config_attributes(/index)(.:format)' => "config_attributes#index", :via => :get
    match '/config_attributes/new(.:format)'      => "config_attributes#new",   :via => :get
    match '/config_attributes/:id/edit(.:format)' => "config_attributes#edit", :via => :get
    match '/config_attributes/create(.:format)'  => "config_attributes#create",:via => :post
    match '/config_attributes/:id(.:format)'  => "config_attributes#update",:via => :put
    match '/config_attributes/:id/show(.:format)'=> "config_attributes#show",  :via => :get
    match '/config_attributes/get_data(.:format)' => "config_attributes#get_data"
    match '/config_attributes/:id/destroy(.:format)' => "config_attributes#destroy", :via => :delete
    match '/config_attributes/:id/multilingual_edit(.:format)' => "config_attributes#multilingual_edit", :via => :get
    match '/config_attributes/:id/multilingual_update(.:format)' => "config_attributes#multilingual_update", :via => :put
  end
end