Rails.application.routes.draw do
  scope :module => "dem" do
    resources :dev_managements do
      collection do
        get "get_data"
      end
    end
  end
end