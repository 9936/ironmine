Ironmine::Application.routes.draw do
  scope :module => "boc" do
    match '/boards(/index)(.:format)' => "boards#index", :via => :get

    match '/board_seconds(/index)(.:format)' => "board_seconds#index", :via => :get

    match '/board_thirds(/index)(.:format)' => "board_thirds#index", :via => :get
  end
end