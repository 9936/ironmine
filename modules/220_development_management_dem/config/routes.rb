Rails.application.routes.draw do
  scope :module => "dem" do
    resources :dev_managements do
      collection do
        get "get_data"
        post "create_phase"
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
  end
end