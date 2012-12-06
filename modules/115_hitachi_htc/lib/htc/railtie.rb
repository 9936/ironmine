module Htc
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentRequest.send(:include, Htc::IncidentRequestModelEx)
    end
  end
end