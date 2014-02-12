class CreateIcmIncidentWorkCalendars < ActiveRecord::Migration
  def change
    create_table :icm_incident_work_calendars do |t|
      t.string   "opu_id", :limit => 22, :null => false
      t.string   "external_system_id",  :limit => 22, :collate => "utf8_bin"
      t.string   "time_zone", :default => "Beijing"
      t.string   "calendar_id",  :limit => 22, :collate => "utf8_bin"
      t.timestamps
    end
  end
end
