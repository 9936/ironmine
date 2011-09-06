class RepairIncidentRequestData < ActiveRecord::Migration
  def self.up
    Icm::IncidentRequest.all.each do |i|
      i.incident_status_id = Icm::IncidentStatus.default_id
      i.urgence_id = Icm::UrgenceCode.default_id
      i.impact_range_id = Icm::ImpactRange.default_id
      i.sync_priority
    end
  end

  def self.down
  end
end
