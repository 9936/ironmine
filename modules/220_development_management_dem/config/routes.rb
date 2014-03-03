Rails.application.routes.draw do
  scope :module => "dem" do
    resources :dev_managements do
      collection do
        get "get_data"
        post "create_phase"
        post "index"
      end
    end

    resources :dev_phase_templates do
      collection do
        get "get_data"
      end
    end

    resources :dev_phases do
      collection do

      end
    end

    resources :projects do
      collection do
        get "get_data"
      end
    end
  end
end