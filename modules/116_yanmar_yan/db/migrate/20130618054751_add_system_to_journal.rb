class AddSystemToJournal < ActiveRecord::Migration
  def change
    add_column :icm_incident_journals, :external_system_id, :string, :limit => 22, :after => :opu_id

    Icm::IncidentJournal.all.each do |t|
      if t.incident_request
        t.update_attribute(:external_system_id, t.incident_request.external_system_id)
      end
    end

  end
end
