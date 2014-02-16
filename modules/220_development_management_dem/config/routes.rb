Rails.application.routes.draw do
  scope :module => "dev" do
    resources :dev_managements do
      collection do
        get "get_data"
      end
    end
  end
end