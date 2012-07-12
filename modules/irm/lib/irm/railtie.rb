module Irm
  class Railtie < Rails::Railtie
    config.to_prepare do
      Irm::SyncDataAccessExtend.instance.extend_data_access_model
    end
    config.before_configuration do
       #sunspot_plus
       require 'sunspot_rails'
       Sunspot.session = Sunspot::SessionProxy::DelayedJobSessionProxy.new(Sunspot.session)
    end
  end
end