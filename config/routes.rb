Ironmine::Application.routes.draw do


  namespace :isp do resources :check_parameters end

  namespace :isp do resources :check_items end

  namespace :isp do resources :programs end

end
