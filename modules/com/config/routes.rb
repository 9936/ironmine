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
     match '/config_relation_members/new(.:format)' => "config_relation_members#new", :via => :get
     match '/config_relation_members/:id(.:format)' => "config_relation_members#show", :via => :get
     match '/config_relation_members/create(.:format)' => "config_relation_members#create", :via => :post

  end
end