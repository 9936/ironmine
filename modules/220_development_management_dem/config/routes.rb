Rails.application.routes.draw do
  scope :module => "dem" do
    resources :dev_managements do
      collection do
        get "get_data"
        post "create_phase"
        get "edit_phase_sequence"
        put "update_phase_sequence"
        post "sindex"
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