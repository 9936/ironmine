Rails.application.routes.draw do
  scope :module => "som" do
    resources :sales_opportunities
    match '/sales_opportunities/get_data(.:format)' => "sales_opportunities#get_data"
  end
end