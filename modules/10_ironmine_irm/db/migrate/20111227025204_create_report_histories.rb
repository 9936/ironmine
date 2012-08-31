class CreateReportHistories < ActiveRecord::Migration
  def up
    create_table "irm_report_request_histories", :force => true do |t|
      t.string   "opu_id",              :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "report_id",           :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "executed_by",         :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "execute_type",        :limit => 30, :null => false
      t.string   "trigger_id",          :limit => 22, :collate=>"utf8_bin"
      t.text     "params"
      t.datetime "start_at"
      t.datetime "end_at"
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_request_histories, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "irm_report_request_histories", ["report_id"], :name => "IRM_REPORT_REQUEST_HISTORIES_N1"

  end


  def down
    drop_table :irm_report_request_histories
  end
end
