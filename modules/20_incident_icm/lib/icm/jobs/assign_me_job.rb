module Icm
  module Jobs
    class AssignMeJob < Struct.new(:incident_request_id,:current_person_id)
      def perform
        Irm::Person.current = Irm::Person.unscoped.find(current_person_id)
        irq = Icm::IncidentRequest.find(incident_request_id)
        return unless irq.support_person_id.nil?
        request_attributes = {}
        journal_attributes = {}
        journal_attributes.merge!(:message_body => I18n.t(:label_icm_incident_request_assign_me))
        journal_attributes.merge!(:reply_type => "ASSIGN_TO_ME")
        journal_attributes.merge!(:replied_by => Irm::Person.current.id)
        request_attributes.merge!({:incident_status_id => Icm::IncidentStatus.transform(irq.incident_status_id, "ASSIGN_TO_ME", irq.external_system_id)})
        request_attributes.merge!({:support_person_id => Irm::Person.current.id, :charge_person_id => Irm::Person.current.id, :upgrade_person_id => Irm::Person.current.id})

        incident_journal = Icm::IncidentJournal::generate_journal(irq, request_attributes, journal_attributes)

        irq.incident_status_id = Icm::IncidentStatus.transform(irq.incident_status_id, incident_journal.reply_type, irq.external_system_id)
        incident_journal.save
        irq.save
      end
    end
  end
end