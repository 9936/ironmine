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

    match '/systems(/index)(.:format)' => "systems#index", :via => :get
    match '/systems/:id/edit(.:format)' => "systems#edit", :via => :get
    match '/systems/:id(.:format)' => "systems#update", :via => :put
    match '/systems/new(.:format)' => "systems#new", :via => :get
    match '/systems/create(.:format)' => "systems#create", :via => :post
    match '/systems/get_data(.:format)' => "systems#get_data"
    match '/systems/:id(.:format)' => "systems#show", :via => :get

    match '/system_people/:system_id/add_people(.:format)' => "system_people#add_people", :via => :post
    match '/system_people/:system_id/get_available_people_data(.:format)' => "system_people#get_available_people_data", :via => :get
  end

end
