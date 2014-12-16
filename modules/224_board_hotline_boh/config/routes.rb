Rails.application.routes.draw do
  scope :module => "boh" do
    resources :boards do
      collection do

      end
    end
  end
end