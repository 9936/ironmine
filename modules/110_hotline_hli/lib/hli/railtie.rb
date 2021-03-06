module Hli
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentRequestsController.send(:include, Hli::IncidentRequestsControllerEx)
      Icm::IncidentJournalsController.send(:include, Hli::IncidentJournalsControllerEx)
      Icm::IncidentRequest.send(:include, Hli::IncidentRequestModelEx)
      Icm::IncidentJournal.send(:include, Hli::IncidentJournalModelEx)
      Icm::IncidentHistory.send(:include, Hli::IncidentHistoryModelEx)
      Icm::IncidentReply.send(:include, Hli::IncidentReplyModelEx)
      Irm::ReportsController.send(:include, Hli::ReportsControllerEx)
      Icm::IncidentRequestsHelper.send(:include, Hli::IncidentRequestsHelperEx)
      Icm::IncidentJournalsHelper.send(:include, Hli::IncidentJournalsHelperEx)
      Irm::WatchersController.send(:include, Hli::WatchersControllerEx)
      Irm::CustomFieldHelper.send(:include, Hli::CustomFieldHelperEx)
    end
  end
end