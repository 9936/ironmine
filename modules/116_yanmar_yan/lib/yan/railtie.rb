module Yan
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentPermissionCheckHelper.send(:include, Yan::IncidentPermissionCheckHelperEx)
      Irm::CustomFieldHelper.send(:include, Yan::CustomFieldHelperEx)
      Icm::IncidentJournal.send(:include, Yan::IncidentJournalModelEx)
      Icm::IncidentJournalsController.send(:include, Yan::IncidentJournalsControllerEx)
      Icm::IncidentRequest.send(:include, Yan::IncidentRequestModelEx)
      Icm::IncidentWorkload.send(:include, Yan::IncidentWorkloadModelEx)
      Irm::Rating.send(:include, Yan::RatingModelEx)
      Icm::IncidentJournalsHelper.send(:include, Yan::IncidentJournalsHelperEx)
      Icm::IncidentRequestsController.send(:include, Yan::IncidentRequestsControllerEx)
      Irm::ExternalSystem.send(:include, Yan::ExternalSystemModelEx)
      Irm::ExternalSystemsHelper.send(:include, Yan::ExternalSystemHelperEx)
      Mam::MasterStatus.send(:include, Yan::MasterStatusModelEx)
      Skm::EntryHeadersController.send(:include, Yan::EntryHeadersControllerEx)
      Skm::EntryHeader.send(:include, Yan::EntryHeaderModelEx)
      Irm::ReportsController.send(:include, Yan::ReportsControllerEx)
    end
  end
end