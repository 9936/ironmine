Ironmine::Application.routes.draw do

  resources :skills

  namespace :slm do resources :time_triggers end

  get "delayed/index"
end
