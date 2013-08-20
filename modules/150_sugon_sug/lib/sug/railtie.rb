module Sug
  class Railtie < Rails::Railtie
    config.to_prepare do
      Irm::Person.send(:include, Sug::PersonModelEx)
    end
  end
end