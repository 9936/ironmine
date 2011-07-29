class CreateReportTriggers < ActiveRecord::Migration
  def self.up
    create_table :irm_report_triggers,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :report_id,:limit=>22, :null => false
      t.string   :person_id,:limit=>22, :null => false
      t.string   :receiver_type,:limit=>22, :null => false
      t.text     :time_mode, :null => false
      t.date :start_at, :null => false
      t.date :end_at, :null => false
      t.datetime :start_time
      t.string   "status_code", :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   "created_by",:limit=>22,:null=>false
      t.string   "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_triggers, :id, :string,:limit=>22, :null => false

    add_index "irm_report_triggers", "report_id", :name => "IRM_REPORT_TRIGGERS_N1"

    create_table :irm_report_receivers do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :report_trigger_id,:limit=>22, :null => false
      t.string  "receiver_type",   :null => false,:limit=>30
      t.string  "receiver_id",     :null => false ,:limit=>22
      t.string   "status_code",     :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_receivers, :id, :string,:limit=>22, :null => false

    create_table :irm_report_schedules do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :report_trigger_id,:limit=>22, :null => false
      t.datetime  "run_at",                :null => false
      t.string    "run_at_str",:limit => 30
      t.string  "run_status",              :limit => 30, :default=>"PENDING"
      t.string   "status_code",            :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_schedules, :id, :string,:limit=>22, :null => false
  end

  def self.down
    drop_table :irm_report_triggers
    drop_table :irm_report_receivers
    drop_table :irm_report_schedules
  end
end
