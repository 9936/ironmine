module Ccc
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentRequestsController.send(:include, Ccc::IncidentRequestsControllerEx)
      Icm::IncidentJournalsController.send(:include, Ccc::IncidentJournalsControllerEx)
      Icm::IncidentRequest.send(:include, Ccc::IncidentRequestModelEx)
      Icm::IncidentJournal.send(:include, Ccc::IncidentJournalModelEx)
      Icm::IncidentHistory.send(:include, Ccc::IncidentHistoryModelEx)
      Icm::IncidentReply.send(:include, Ccc::IncidentReplyModelEx)
      Irm::ReportsController.send(:include, Ccc::ReportsControllerEx)
      Icm::IncidentRequestsHelper.send(:include, Ccc::IncidentRequestsHelperEx)
      Icm::IncidentJournalsHelper.send(:include, Ccc::IncidentJournalsHelperEx)
      Irm::WatchersController.send(:include, Ccc::WatchersControllerEx)
      Irm::CustomFieldHelper.send(:include, Ccc::CustomFieldHelperEx)
      Irm::BulletinsController.send(:include, Ccc::BulletinsControllerEx)
      Irm::Person.send(:include, Ccc::PersonModelEx)
    end
  end
end