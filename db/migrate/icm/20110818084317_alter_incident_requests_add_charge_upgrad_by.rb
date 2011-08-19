class AlterIncidentRequestsAddChargeUpgradBy < ActiveRecord::Migration
  def self.up
    add_column :icm_incident_requests,:charge_person_id,:string,:limit=>22,:after=>:support_person_id
    add_column :icm_incident_requests,:charge_group_id,:string,:limit=>22,:after=>:support_person_id
    add_column :icm_incident_requests,:upgrade_person_id,:string,:limit=>22,:after=>:support_person_id
    add_column :icm_incident_requests,:upgrade_group_id,:string,:limit=>22,:after=>:support_person_id
    add_column :irm_watchers,:deletable_flag,:string,:limit=>1,:default=>"Y",:after=>:member_type
  end

  def self.down
    remove_column :icm_incident_requests,:charge_person_id
    remove_column :icm_incident_requests,:charge_group_id
    remove_column :icm_incident_requests,:upgrade_person_id
    remove_column :icm_incident_requests,:upgrade_group_id
    remove_column :irm_watchers,:deletable_flag
  end
end
