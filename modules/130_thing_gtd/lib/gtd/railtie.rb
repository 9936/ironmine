module Hli
  class Railtie < Rails::Railtie
    config.to_prepare do
      Irm::Person.send(:include, Gtd::PersonEx)
    end
  end
end