module Htc
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentRequest.send(:include, Htc::IncidentRequestModelEx)
      Icm::IncidentRequestsController.send(:include, Htc::IncidentRequestsControllerEx)
      Skm::EntryHeadersController.send(:include, Htc::EntryHeadersControllerEx)
    end
  end
end