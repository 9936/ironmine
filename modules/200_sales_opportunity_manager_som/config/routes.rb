Rails.application.routes.draw do
  scope :module => "som" do
    match '/sales_opportunities/get_data(.:format)' => "sales_opportunities#get_data"
    resources :sales_opportunities

    match '/potential_customers/get_data(.:format)' => "potential_customers#get_data"
    resources :potential_customers

    match '/communicate_infos/get_data(.:format)' => "communicate_infos#get_data"
    resources :communicate_infos
  end
end