module Ndm
  class Railtie < Rails::Railtie
    config.to_prepare do
      Irm::Person.send(:include, Ndm::PersonModelEx)
    end
  end
end