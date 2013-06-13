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
    match '/ebs_modules/:id/multilingual_edit(.:format)' => "ebs_modules#multilingual_edit", :via => :get
    match '/ebs_modules/:id/multilingual_update(.:format)' => "ebs_modules#multilingual_update", :via => :put
  end
end