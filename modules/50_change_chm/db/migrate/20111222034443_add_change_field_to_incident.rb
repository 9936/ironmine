class AddChangeFieldToIncident < ActiveRecord::Migration
  def change
    add_column :icm_incident_requests,:change_requested_at,:datetime
    add_column :icm_incident_requests,:change_request_id,:string,:limit => 22, :collate=>"utf8_bin",:after=>:next_reply_user_license

  end
end
