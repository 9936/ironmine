Rails.application.routes.draw do
  scope :module => "sug" do
    #Sug_country
    match '/countries(/index)(.:format)' => "countries#index", :via => :get
    match '/countries/get_data(.:format)' => "countries#get_data"
    match '/countries/:id/edit(.:format)' => "countries#edit", :via => :get
    match '/countries/:id(.:format)' => "countries#update", :via => :put
    match '/countries/new(.:format)' => "countries#new", :via => :get
    match '/countries/:id/get_province_data(.:format)' => "countries#get_province_data", :via => :get
    match '/countries/:id(.:format)' => "countries#show", :via => :get
    match '/countries/create(.:format)' => "countries#create", :via => :post


    #Sug_province
    match '/provinces/:id/get_city_data(.:format)' => "provinces#get_city_data", :via => :get
    match '/provinces/:country_id/get_data(.:format)' => "provinces#get_data"
    match '/provinces/:country_id/:id/edit(.:format)' => "provinces#edit", :via => :get
    match '/provinces/:country_id/:id(.:format)' => "provinces#update", :via => :put
    match '/provinces/:country_id/new(.:format)' => "provinces#new", :via => :get
    match '/provinces/:country_id/:id(.:format)' => "provinces#show", :via => :get
    match '/provinces/:country_id/create(.:format)' => "provinces#create", :via => :post


    #Sug_city
    match '/cities/:id/get_district_data(.:format)' => "cities#get_district_data", :via => :get
    match '/cities/:province_id/get_data(.:format)' => "cities#get_data"
    match '/cities/:province_id/:id/edit(.:format)' => "cities#edit", :via => :get
    match '/cities/:province_id/:id(.:format)' => "cities#update", :via => :put
    match '/cities/:province_id/new(.:format)' => "cities#new", :via => :get
    match '/cities/:province_id/:id(.:format)' => "cities#show", :via => :get
    match '/cities/:province_id/create(.:format)' => "cities#create", :via => :post


    #Sug_district
    match '/districts/:city_id/get_data(.:format)' => "districts#get_data"
    match '/districts/:city_id/:id/edit(.:format)' => "districts#edit", :via => :get
    match '/districts/:city_id/:id(.:format)' => "districts#update", :via => :put
    match '/districts/:city_id/new(.:format)' => "districts#new", :via => :get
    match '/districts/:city_id/:id(.:format)' => "districts#show", :via => :get
    match '/districts/:city_id/create(.:format)' => "districts#create", :via => :post

    #Sug_customer
    match '/customers/get_data(.:format)' => "customers#get_data"
    match '/customers(/index)(.:format)' => "customers#index", :via => :get
    match '/customers/:id/edit(.:format)' => "customers#edit", :via => :get
    match '/customers/new(.:format)' => "customers#new", :via => :get
    match '/customers/:id/show(.:format)' => "customers#show", :via => :get
    match '/customers/create(.:format)' => "customers#create", :via => :post
    match '/customers/:id/update(.:format)' => "customers#update", :via => :put

    #
  end
end