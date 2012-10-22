class ChangeJournalsDefaultValue < ActiveRecord::Migration
  def up
    change_column :icm_incident_journals, "status_code", :string, :limit => 30, :default => "ENABLED",:null => false
  end

  def down
    change_column :icm_incident_journals, "status_code", :string, :limit => 30,:null => false
  end
end
