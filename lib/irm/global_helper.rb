module Irm
  class GlobalHelper
    include Singleton
    include ActionController::UrlWriter


    def absolute_url(options)
      url_for({:host=>Irm::SystemParametersManager.host_name}.merge(options))
    end

    def url(options)
      url_for(options)
    end
  end
end