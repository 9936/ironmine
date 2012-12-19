module Htc
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentRequest.send(:include, Htc::IncidentRequestModelEx)
      Icm::IncidentRequestsController.send(:include, Htc::IncidentRequestsControllerEx)
    end
  end
end