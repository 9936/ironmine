Ironmine::Application.routes.draw do

  namespace :slm do resources :time_triggers end

  get "delayed/index"
end
