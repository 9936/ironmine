class CreateAlertFilters < ActiveRecord::Migration
  def change
    create_table :isp_alert_filters, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "check_item_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "result_type", :limit => 30, :null => false
      t.string "operation", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string "value"
      t.string "status_code", :limit => 30, :default => "ENABLED"
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :isp_alert_filters, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "isp_alert_filters", ["check_item_id"], :name => "SIP_ALERT_FILTER_N1"
  end
end
