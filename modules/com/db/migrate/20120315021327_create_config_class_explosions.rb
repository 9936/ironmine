class CreateConfigClassExplosions < ActiveRecord::Migration
  def up
    create_table "com_config_class_explosions", :force => true do |t|
      t.string   "parent_id",        :limit => 22,                        :null => false
      t.string   "direct_parent_id", :limit => 22,                        :null => false
      t.string   "config_class_id",      :limit => 22,                        :null => false
      t.string   "opu_id",               :limit => 22,                        :null => false
      t.string   "status_code",          :limit => 30, :default => "ENABLED"
      t.string   "created_by",           :limit => 22,                        :null => false
      t.string   "updated_by",           :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "com_config_class_explosions", ["parent_id", "direct_parent_id", "config_class_id"], :name => "COM_CLASS_CONFIG_EXPLOSIONS_U1", :unique => true
  end

  def down
    drop_table "com_config_class_explosions"
  end
end
