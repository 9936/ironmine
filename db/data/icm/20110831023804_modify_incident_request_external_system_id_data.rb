class ModifyIncidentRequestExternalSystemIdData < ActiveRecord::Migration
  def self.up
    Icm::IncidentRequest.where("1=1").each do |t|
      es = Irm::ExternalSystem.where("external_system_code=?", t.external_system_id).enabled
      t.update_attribute(:external_system_id, es.first.id) if es.any?
    end
  end

  def self.down
    Icm::IncidentRequest.where("1=1").each do |t|
      es = Irm::ExternalSystem.where("id=?", t.external_system_id).enabled
      t.update_attribute(:external_system_id, es.first.external_system_code) if es.any?
    end
  end
end
