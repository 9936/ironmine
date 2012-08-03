module Irm
  class GlobalHelper
    include Singleton
    include Rails.application.routes.url_helpers

    def absolute_url(options)
      url_for({:host=>Irm::SystemParametersManager.host_name||"0.0.0.0",:port=>Irm::SystemParametersManager.host_port||80}.merge(options))
    end

    def url(options)
      url_for({:only_path=>true}.merge(options))
    end
  end
end