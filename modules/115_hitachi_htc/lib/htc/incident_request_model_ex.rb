module Htc::IncidentRequestModelEx
  def self.included(base)
    base.class_eval do
      validates_presence_of :incident_category_id, :incident_sub_category_id

      private
        def generate_request_number
          system = Irm::ExternalSystem.find(self.external_system_id)
          self.request_number = Irm::Sequence.nextval(system.external_system_code)
          self.request_number = Irm::Sequence.nextval(Icm::IncidentRequest.name) if self.request_number == -1
          self.save
          self.add_watcher(Irm::Person.find(self.support_person_id),false) if self.support_person_id.present?
          self.add_watcher(Irm::Person.find(self.requested_by),false)
          self.add_watcher(Irm::Person.find(self.submitted_by),false)
        end
    end
  end
end