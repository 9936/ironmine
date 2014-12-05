Ironmine::Application.routes.draw do

  scope :module => "mam" do
    match '/masters(/index)(.:format)' => "masters#index", :via => :get
    match '/masters/:id/edit(.:format)' => "masters#edit", :via => :get

    match '/masters/:id(.:format)' => "masters#update", :via => :put
    match '/masters/new(.:format)' => "masters#new", :via => :get
    match '/masters/new_item(.:format)' => "masters#new_item", :via => :get
    match '/masters/new_scs(.:format)' => "masters#new_scs", :via => :get
    match '/masters/new_urs(.:format)' => "masters#new_urs", :via => :get
    match '/masters/:id/edit_item(.:format)' => "masters#edit_item", :via => :get
    match '/masters/:id/edit_scs(.:format)' => "masters#edit_scs", :via => :get
    match '/masters/:id/edit_urs(.:format)' => "masters#edit_urs", :via => :get
    match '/masters/:id/update_item(.:format)' => "masters#update_item", :via => [:post, :put]
    match '/masters/:id/update_scs(.:format)' => "masters#update_scs", :via => [:post, :put]
    match '/masters/:id/update_urs(.:format)' => "masters#update_urs", :via => [:post, :put]
    match '/masters/create_item(.:format)' => "masters#create_item", :via => :post
    match '/masters/create_scs(.:format)' => "masters#create_scs", :via => :post
    match '/masters/create_urs(.:format)' => "masters#create_urs", :via => :post
    match '/masters/create(.:format)' => "masters#create", :via => :post
    match '/masters/get_data(.:format)' => "masters#get_data"

    match '/masters/:id(.:format)' => "masters#show", :via => :get
    match '/masters/:master_id/get_item_data(.:format)' => "masters#get_item_data", :via => :get
    match '/masters/:master_id/get_ur_data(.:format)' => "masters#get_ur_data", :via => :get
    match '/masters/:master_id/add_item(.:format)' => "masters#add_item"
    match '/masters/:master_id/add_ur(.:format)' => "masters#add_ur"
    match '/masters/:master_id/create_item(.:format)' => "masters#create_item", :via => :post
    match '/masters/:master_id/create_ur(.:format)' => "masters#create_item", :via => :post
    match '/masters/create_sc(.:format)' => "masters#create_sc", :via => :post
    match '/masters/:master_id/delete_item(.:format)' => "masters#delete_item", :via => [:delete,:get]
    match '/masters/:master_id/delete_ur(.:format)' => "masters#delete_ur", :via => [:delete,:get]
    match '/masters/:master_id/create_reply(.:format)' => "masters#create_reply", :via => :post

    match '/masters/:master_id/update_status(.:format)' => "masters#update_status", :via => [:post, :put, :get]
    match '/masters/:master_id/update_assign(.:format)' => "masters#update_assign", :via => [:post, :put, :get]

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

    match '/systems/:system_id/add_support_groups(.:format)' => "systems#add_support_groups", :via => :get
    match '/systems/:system_id/delete_support_group(.:format)' => "systems#delete_support_group", :via => [:delete,:get]
    match '/systems/:system_id/get_owned_groups_data(.:format)' => "systems#get_owned_groups_data", :via => :get
    match '/systems/:system_id/get_groupable_data(.:format)' => "systems#get_groupable_data", :via => :get
    match '/systems/:system_id/add_support_group_create(.:format)' => "systems#add_support_group_create", :via => :post

  end

end
