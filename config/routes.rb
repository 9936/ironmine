Ironmine::Application.routes.draw do

  resources :notify_programs

  namespace :slm do resources :time_triggers end

  get "delayed/index"

end
