class FillJournalsExternalSystemId < ActiveRecord::Migration
  def up
    #Fill Datas
    Icm::IncidentJournal.where("incident_request_id IS NOT NULL").each do |ij|
      next unless ij.incident_request.external_system_id.present?
      ij.update_attribute(:external_system_id, ij.incident_request.external_system_id)
    end
  end

  def down
  end
end
