module Yan
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentJournal.send(:include, Yan::IncidentJournalModelEx)
    end
  end
end