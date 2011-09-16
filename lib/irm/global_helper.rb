module Irm
  class GlobalHelper
    include Singleton
    include Rails.application.routes.url_helpers

    def absolute_url(options)
      url_for({:host=>Irm::SystemParametersManager.host_name,:port=>Irm::SystemParametersManager.host_port}.merge(options))
    end

    def url(options)
      url_for(options)
    end
  end
end