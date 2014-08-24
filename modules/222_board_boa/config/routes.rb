Rails.application.routes.draw do
  scope :module => "boa" do
    resources :boards do
      collection do

      end
    end
  end
end