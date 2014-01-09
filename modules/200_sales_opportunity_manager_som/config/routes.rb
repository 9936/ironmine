Rails.application.routes.draw do
  scope :module => "som" do
    resources :sales_opportunities do
      member do
        get "edit_reason"
        put "update_reason"
      end
      collection do
        get "get_data"
      end
    end

    resources :potential_customers do
      collection do
        get "get_data"
        get "new_modal"
        post "create_modal"
        get "get_options"
      end
    end

    resources :communicate_infos do
      collection do
        get "get_data"
      end
    end
  end
end