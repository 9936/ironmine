module Yan
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentPermissionCheckHelper.send(:include, Yan::IncidentPermissionCheckHelperEx)
      CustomFieldHelper.send(:include, Yan::CustomFieldHelperEx)
      Icm::IncidentJournal.send(:include, Yan::IncidentJournalModelEx)
      Icm::IncidentJournalsController.send(:include, Yan::IncidentJournalsControllerEx)
    end
  end
end