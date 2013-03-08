class CreateSlaTables < ActiveRecord::Migration
  def up
    drop_table :slm_service_agreements
    drop_table :slm_service_agreements_tl
    execute('DROP VIEW slm_service_agreements_vl')

    create_table "slm_service_agreements", :force => true do |t|
      t.string "opu_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "external_system_id",:limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "business_object_code", :limit => 30, :null => false
      t.string "time_zone", :null => false
      t.string "calendar_id", :limit => 22
      t.string "duration"
      t.string "start_rule_filter_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "start_cux_rule_filter"
      t.string "pause_rule_filter_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "pause_cux_rule_filter"
      t.string "stop_rule_filter_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "stop_cux_rule_filter"
      t.string "cancel_rule_filter_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "cancel_cux_rule_filter"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.string "created_by", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_service_agreements, "id", :string, :limit => 22, :collate => "utf8_bin"


    create_table "slm_service_agreements_tl", :force => true do |t|
      t.string "opu_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "service_agreement_id",:limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "name", :limit => 30, :null => false
      t.string "description", :limit => 150
      t.string "language", :limit => 30
      t.string "source_lang", :limit => 30
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.integer "created_by", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.integer "updated_by",:limit => 22,  :null => false, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_service_agreements_tl, "id", :string, :limit => 22, :collate => "utf8_bin"


    add_index "slm_service_agreements_tl", ["service_agreement_id", "language"], :name => "SLM_SERVICE_AGREEMENTS_TL_U1", :unique => true

    execute('CREATE OR REPLACE VIEW slm_service_agreements_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                     FROM slm_service_agreements t,slm_service_agreements_tl tl
                                                     WHERE t.id = tl.service_agreement_id')



    create_table "slm_time_triggers", :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "service_agreement_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.integer "duration_percent",  :null => false
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.integer "created_by", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.integer "updated_by",:limit => 22,  :null => false, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_time_triggers, "id", :string, :limit => 22, :collate => "utf8_bin"



    create_table "slm_time_trigger_actions", :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "time_trigger_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "action_type", :limit => 30, :null => false
      t.string "action_id", :limit => 22,:limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.integer "created_by",:limit => 22,  :null => false, :collate => "utf8_bin"
      t.integer "updated_by" ,:limit => 22,  :null => false, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_time_trigger_actions, "id", :string, :limit => 22, :collate => "utf8_bin"

  end

  def down
    drop_table :slm_service_agreements
    drop_table :slm_service_agreements_tl
    execute('DROP VIEW slm_service_agreements_vl')

    create_table "slm_service_agreements", :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "external_system_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "business_object_code", :limit => 30, :null => false
      t.string "time_zone", :null => false
      t.string "calendar_id", :limit => 22, :collate => "utf8_bin"
      t.string "duration"
      t.string "start_rule_filter_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "start_cux_rule_filter"
      t.string "pause_rule_filter_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "pause_cux_rule_filter"
      t.string "stop_rule_filter_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "stop_cux_rule_filter"
      t.string "cancel_rule_filter_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "cancel_cux_rule_filter"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.string "created_by", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "slm_service_agreements_tl", :force => true do |t|
      t.string "opu_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "service_agreement_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string "name", :limit => 30, :null => false
      t.string "description", :limit => 150
      t.string "language", :limit => 30
      t.string "source_lang", :limit => 30
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.integer "created_by" ,:limit => 22,  :null => false, :collate => "utf8_bin"
      t.integer "updated_by",:limit => 22,  :null => false, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "slm_service_agreements_tl", ["service_agreement_id", "language"], :name => "SLM_SERVICE_AGREEMENTS_TL_U1", :unique => true

    execute('CREATE OR REPLACE VIEW slm_service_agreements_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                     FROM slm_service_agreements t,slm_service_agreements_tl tl
                                                     WHERE t.id = tl.group_id')


    drop_table :slm_time_triggers
    drop_table :slm_time_trigger_actions
  end
end
