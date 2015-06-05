Rails.application.routes.draw do
  scope :module => "boy" do
    resources :boards do
      collection do

      end
    end
  end
end