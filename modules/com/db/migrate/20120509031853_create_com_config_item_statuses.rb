class CreateComConfigItemStatuses < ActiveRecord::Migration
  def up
    create_table "com_config_item_statuses", :force => true do |t|
      t.string   "opu_id",               :limit => 22,                  :null => false
      t.string   "code",                 :limit => 30,                  :null => false
      t.integer  "display_sequence"
      t.string   "default_flag",         :limit => 1,  :default => "N"
      t.string   "close_flag",           :limit => 1,  :default => "N", :null => false
      t.string   "status_code",          :limit => 30,                  :null => false
      t.string   "created_by",           :limit => 22
      t.string   "updated_by",           :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :com_config_item_statuses, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "com_config_item_statuses", ["code"], :name => "COM_CONFIG_ITEM_STATUSES_N1"

    create_table "com_config_item_statuses_tl", :force => true do |t|
      t.string   "opu_id",             :limit => 22
      t.string   "config_item_status_id", :limit => 22
      t.string   "language",           :limit => 30,  :null => false
      t.string   "name",               :limit => 150
      t.string   "description",        :limit => 240
      t.string   "source_lang",        :limit => 30,  :null => false
      t.string   "status_code",        :limit => 30,  :null => false
      t.string   "created_by",         :limit => 22
      t.string   "updated_by",         :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :com_config_item_statuses, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "com_config_item_statuses_tl", ["config_item_status_id", "language"], :name => "COM_CONFIG_ITEM_STATUSES_TL_U1", :unique => true
    add_index "com_config_item_statuses_tl", ["config_item_status_id"], :name => "COM_CONFIG_ITEM_STATUSES_TL_N1"

    execute('CREATE OR REPLACE VIEW com_config_item_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                               FROM com_config_item_statuses t,com_config_item_statuses_tl tl
                                               WHERE t.id = tl.config_item_status_id')
  end

  def down
    drop_table :com_config_item_statuses
    drop_table :com_config_item_statuses_tl
    execute('DROP VIEW com_config_item_statuses_vl')
  end
end
