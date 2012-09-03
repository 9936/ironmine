class CreateChmChangeRequests < ActiveRecord::Migration
  def up
    create_table "chm_change_requests", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "request_number"
      t.string   "title",                   :limit => 150,:null => false
      t.text     "summary",                               :null => false
      t.string   "requested_by" ,           :limit => 22, :collate=>"utf8_bin",:null => false
      t.string   "organization_id",         :limit => 22, :collate=>"utf8_bin",:null => false
      t.string   "submitted_by",            :limit => 22, :collate=>"utf8_bin",:null => false
      t.datetime "submitted_date"          ,:null => false
      t.datetime "close_date"
      t.string   "contact_id",              :limit => 22, :collate=>"utf8_bin",:null => false
      t.string   "contact_number",          :limit => 30
      t.string   "external_system_id" ,     :limit => 22, :collate=>"utf8_bin"
      t.string   "category_id" ,            :limit => 22, :collate=>"utf8_bin"
      t.string   "sub_category_id" ,        :limit => 22, :collate=>"utf8_bin"
      t.string   "request_type",            :limit => 30
      t.string   "change_status_id",        :limit => 22, :collate=>"utf8_bin"
      t.string   "change_priority_id",      :limit => 22, :collate=>"utf8_bin"
      t.string   "change_impact_id",        :limit => 22, :collate=>"utf8_bin"
      t.string   "change_urgency_id",       :limit => 22, :collate=>"utf8_bin"
      t.string   "support_group_id",        :limit => 22, :collate=>"utf8_bin"
      t.string   "support_person_id",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "plan_start_date"
      t.datetime "plan_end_date"
      t.string   "approve_flag",            :limit => 1, :collate=>"utf8_bin"
      t.string   "incident_request_id" ,    :limit => 22, :collate=>"utf8_bin"
      t.string   "status_code",             :limit => 30, :null => false
      t.string   "created_by",              :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",              :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_requests, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end

  def down
    drop_table :chm_change_requests
  end
end
