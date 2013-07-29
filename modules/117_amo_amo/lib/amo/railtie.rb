module Amo
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentPermissionCheckHelper.send(:include, Amo::IncidentPermissionCheckHelperEx)
      Irm::CustomFieldHelper.send(:include, Amo::CustomFieldHelperEx)
      Icm::IncidentJournal.send(:include, Amo::IncidentJournalModelEx)
      Icm::IncidentJournalsController.send(:include, Amo::IncidentJournalsControllerEx)
      Icm::IncidentRequest.send(:include, Amo::IncidentRequestModelEx)
      Icm::IncidentWorkload.send(:include, Amo::IncidentWorkloadModelEx)
      Irm::Rating.send(:include, Amo::RatingModelEx)
    end
  end
end