Ironmine::Application.routes.draw do

  scope :module => "mam" do
    match '/masters(/index)(.:format)' => "masters#index", :via => :get
    match '/masters/:id/edit(.:format)' => "masters#edit", :via => :get
    match '/masters/:id(.:format)' => "masters#update", :via => :put
    match '/masters/new(.:format)' => "masters#new", :via => :get
    match '/masters/new_item(.:format)' => "masters#new_item", :via => :get
    match '/masters/new_scs(.:format)' => "masters#new_scs", :via => :get
    match '/masters/new_urs(.:format)' => "masters#new_urs", :via => :get
    match '/masters/create_item(.:format)' => "masters#create_item", :via => :get
    match '/masters/create_scs(.:format)' => "masters#create_scs", :via => :get
    match '/masters/create_urs(.:format)' => "masters#create_urs", :via => :get
    match '/masters/create(.:format)' => "masters#create", :via => :post
    match '/masters/get_data(.:format)' => "masters#get_data"
    match '/masters/:id(.:format)' => "masters#show", :via => :get
    match '/masters/:master_id/get_item_data(.:format)' => "masters#get_item_data", :via => :get
    match '/masters/:master_id/add_item(.:format)' => "masters#add_item"
    match '/masters/:master_id/create_item(.:format)' => "masters#create_item", :via => :post
    match '/masters/create_sc(.:format)' => "masters#create_sc", :via => :post
    match '/masters/:master_id/delete_item(.:format)' => "masters#delete_item", :via => [:delete,:get]

    match '/systems(/index)(.:format)' => "systems#index", :via => :get
    match '/systems/:id/edit(.:format)' => "systems#edit", :via => :get
    match '/systems/:id(.:format)' => "systems#update", :via => :put
    match '/systems/new(.:format)' => "systems#new", :via => :get
    match '/systems/create(.:format)' => "systems#create", :via => :post
    match '/systems/get_data(.:format)' => "systems#get_data"
    match '/systems/:id(.:format)' => "systems#show", :via => :get

    match '/systems/:system_id/add_people(.:format)' => "systems#add_people", :via => :get
    match '/systems/:system_id/delete_person(.:format)' => "systems#delete_person", :via => [:delete,:get]
    match '/systems/:system_id/get_owned_members_data(.:format)' => "systems#get_owned_members_data", :via => :get
    match '/systems/:system_id/get_memberable_data(.:format)' => "systems#get_memberable_data", :via => :get
    match '/systems/:system_id/add_people(.:format)' => "systems#add_people_create", :via => :post

  end

end
