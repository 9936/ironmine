class PriorityTransform < ActiveRecord::Migration
  def change
    create_table "icm_priority_transforms", :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "sid", :limit => 22
      t.string "urgence_id", :limit => 22,  :collate => "utf8_bin"
      t.string "impact_range_id", :limit => 22, :collate => "utf8_bin"
      t.string "priority_id", :limit => 30
      t.string "status_code", :limit => 30, :default => "ENABLED", :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_priority_transforms, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index "icm_priority_transforms", ["sid", "urgence_id", "impact_range_id"], :name => "IRM_PRIORITY_TRANSFORMS", :unique => true
  end
end
