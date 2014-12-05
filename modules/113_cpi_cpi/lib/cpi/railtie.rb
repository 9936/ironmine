module Cpi
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentRequestsController.send(:include, Cpi::IncidentRequestsControllerEx)
      Icm::IncidentJournalsController.send(:include, Cpi::IncidentJournalsControllerEx)
      Icm::IncidentRequest.send(:include, Cpi::IncidentRequestModelEx)
      Icm::IncidentJournal.send(:include, Cpi::IncidentJournalModelEx)
      Icm::IncidentHistory.send(:include, Cpi::IncidentHistoryModelEx)
      Icm::IncidentReply.send(:include, Cpi::IncidentReplyModelEx)
      Irm::ReportsController.send(:include, Cpi::ReportsControllerEx)
      Icm::IncidentRequestsHelper.send(:include, Cpi::IncidentRequestsHelperEx)
      Icm::IncidentJournalsHelper.send(:include, Cpi::IncidentJournalsHelperEx)
      Irm::WatchersController.send(:include, Cpi::WatchersControllerEx)
      Irm::CustomFieldHelper.send(:include, Cpi::CustomFieldHelperEx)
    end
  end
end