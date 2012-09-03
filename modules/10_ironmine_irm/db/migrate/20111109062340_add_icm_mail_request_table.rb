class AddIcmMailRequestTable < ActiveRecord::Migration
  def up
    create_table :icm_mail_requests, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "username", :limit => 60, :null => false
      t.string "password", :limit => 30, :null => false
      t.string "external_system_id", :limit => 22, :null => false
      t.string "service_code", :limit => 30, :null => false
      t.string "impact_range_id", :limit => 22
      t.string "urgency_id", :limit => 22
      t.string "support_group_id", :limit => 22
      t.string "support_person_id", :limit => 22
      t.string "request_type_code", :limit => 30
      t.string "report_source_code", :limit => 30
      t.string "incident_status_id", :limit => 22
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    drop_table :icm_mail_requests
  end
end
