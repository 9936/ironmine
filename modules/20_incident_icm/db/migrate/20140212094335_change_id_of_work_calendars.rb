class ChangeIdOfWorkCalendars < ActiveRecord::Migration
  def change
    change_column :icm_incident_work_calendars, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
