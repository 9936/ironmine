module Irm
  class Railtie < Rails::Railtie
    config.to_prepare do
      Irm::SyncDataAccessExtend.instance.extend_data_access_model
    end
  end
end