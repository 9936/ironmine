Rails.application.routes.draw do
  scope :module => "ndm" do
    resources :dev_managements do
      collection do
        get "get_data"
        post "create_phase"
        get "edit_phase_sequence"
        put "update_phase_sequence"
        post "sindex"
        get "phase_edit"
        put "phase_update"
        get "import_excel"
        post "import_excel_create"
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
        get "get_available_people_data"
        post "add_people"
        get "get_member_data"
        post "delete_people"
        get "get_owned_members_data"
        post "update_project_people"
      end
    end
  end
end