Rails.application.routes.draw do
  scope :module => "win" do
    match '/order_bases(/index)(.:format)' => "order_bases#index", :via => :get
    match '/order_bases/import(.:format)' => "order_bases#import", :via => :post
    match '/order_bases/get_data(.:format)' => "order_bases#get_data", :via => :get

    match '/customer_orders(/index)(.:format)' => "customer_orders#index", :via => :get
    match '/customer_orders/import(.:format)' => "customer_orders#import", :via => :post
    match '/customer_orders/get_data(.:format)' => "customer_orders#get_data", :via => :get
  end
end