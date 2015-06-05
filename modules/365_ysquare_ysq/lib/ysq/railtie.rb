module Ysq
  class Railtie < Rails::Railtie
    config.to_prepare do
      Icm::IncidentPermissionCheckHelper.send(:include, Ysq::IncidentPermissionCheckHelperEx)
      Irm::CustomFieldHelper.send(:include, Ysq::CustomFieldHelperEx)
      Icm::IncidentJournal.send(:include, Ysq::IncidentJournalModelEx)
      Icm::IncidentJournalsController.send(:include, Ysq::IncidentJournalsControllerEx)
      Icm::IncidentRequest.send(:include, Ysq::IncidentRequestModelEx)
      Icm::IncidentWorkload.send(:include, Ysq::IncidentWorkloadModelEx)
      Irm::Rating.send(:include, Ysq::RatingModelEx)
      Icm::IncidentJournalsHelper.send(:include, Ysq::IncidentJournalsHelperEx)
      Icm::IncidentRequestsController.send(:include, Ysq::IncidentRequestsControllerEx)
    end
  end
end