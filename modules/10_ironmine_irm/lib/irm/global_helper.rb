module Irm
  class GlobalHelper
    include Singleton
    include Rails.application.routes.url_helpers

    def absolute_url(options)
      #url_for({:host=>Irm::SystemParametersManager.host_name||"0.0.0.0",:port=>Irm::SystemParametersManager.host_port||80}.merge(options))
      if Irm::SystemParametersManager.host_port.eql?("443")
        options = options.merge({:protocol => 'https'})
        return url_for({:host=>Irm::SystemParametersManager.host_name}.merge(options))
      elsif Irm::SystemParametersManager.host_port.eql?("80")
        return url_for({:host=>Irm::SystemParametersManager.host_name}.merge(options))
      else
        return url_for({:host=>Irm::SystemParametersManager.host_name,:port=>Irm::SystemParametersManager.host_port}.merge(options))
      end
    end

    def url(options)
      url_for({:only_path=>true}.merge(options))
    end
  end
end