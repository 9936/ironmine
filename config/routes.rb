Ironmine::Application.routes.draw do

  namespace :emw do resources :databases end

  namespace :slm do resources :time_triggers end

  get "delayed/index"
end
