Rails.application.routes.draw do
  scope :module => "som" do
    match '/sales_opportunities/get_data(.:format)' => "sales_opportunities#get_data"
    resources :sales_opportunities
  end
end