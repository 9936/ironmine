Rails.application.routes.draw do
  scope :module => "boc" do
    resources :boards do
      collection do

      end
    end
  end
end