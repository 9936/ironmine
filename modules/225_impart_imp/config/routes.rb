Rails.application.routes.draw do
  scope :module => "imp" do
    resources :uis do
      collection do

      end
    end
  end
end