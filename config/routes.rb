Ironmine::Application.routes.draw do
  resources :interfaces

  #resources :notify_programs

  namespace :slm do resources :time_triggers end

  get "delayed/index"

end
