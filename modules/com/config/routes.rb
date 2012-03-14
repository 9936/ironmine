Rails.application.routes.draw do
  scope :module => "com" do

     #config_relation_types
     match '/config_relation_types(/index)(.:format)' => "config_relation_types#index", :via => :get
     match '/config_relation_types/get_data(.:format)' => "config_relation_types#get_data"
     match '/config_relation_types/:id/edit(.:format)' => "config_relation_types#edit", :via => :get
     match '/config_relation_types/:id(.:format)' => "config_relation_types#update", :via => :put
     match '/config_relation_types/new(.:format)' => "config_relation_types#new", :via => :get
     match '/config_relation_types/:id(.:format)' => "config_relation_types#show", :via => :get
     match '/config_relation_types/create(.:format)' => "config_relation_types#create", :via => :post
     match '/config_relation_types/:id/multilingual_edit(.:format)' => "config_relation_types#multilingual_edit", :via => :get
     match '/config_relation_types/:id/multilingual_update(.:format)' => "config_relation_types#multilingual_update", :via => :put

     #config_relation_members
     match '/config_relation_members(/index)(.:format)' => "config_relation_members#index", :via => :get
     match '/config_relation_members/get_data(.:format)' => "config_relation_members#get_data"
     match '/config_relation_members/:id/edit(.:format)' => "config_relation_members#edit", :via => :get
     match '/config_relation_members/:id(.:format)' => "config_relation_members#update", :via => :put
     match '/config_relation_members/:config_relation_type_id/new(.:format)' => "config_relation_members#new", :via => :get
     match '/config_relation_members/:id(.:format)' => "config_relation_members#show", :via => :get
     match '/config_relation_members/create(.:format)' => "config_relation_members#create", :via => :post

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