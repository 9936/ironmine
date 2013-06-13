Rails.application.routes.draw do
  scope :module => "emw" do
    #Ebs_modules
    match '/ebs_modules(/index)(.:format)' => "ebs_modules#index", :via => :get
    match '/ebs_modules/get_data(.:format)' => "ebs_modules#get_data"
    match '/ebs_modules/:id/edit(.:format)' => "ebs_modules#edit", :via => :get
    match '/ebs_modules/:id(.:format)' => "ebs_modules#update", :via => :put
    match '/ebs_modules/new(.:format)' => "ebs_modules#new", :via => :get
    match '/ebs_modules/:id(.:format)' => "ebs_modules#show", :via => :get
    match '/ebs_modules/create(.:format)' => "ebs_modules#create", :via => :post

    #Interface
    match '/interfaces(/index)(.:format)' => "interfaces#index", :via => :get
    match '/interfaces/get_data(.:format)' => "interfaces#get_data"
    match '/interfaces/:id/edit(.:format)' => "interfaces#edit", :via => :get
    match '/interfaces/:id(.:format)' => "interfaces#update", :via => :put
    match '/interfaces/new(.:format)' => "interfaces#new", :via => :get
    match '/interfaces/:id(.:format)' => "interfaces#show", :via => :get
    match '/interfaces/create(.:format)' => "interfaces#create", :via => :post
  end
end