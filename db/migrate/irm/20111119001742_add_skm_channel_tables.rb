class AddSkmChannelTables < ActiveRecord::Migration
  def up
    create_table :skm_channels, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "channel_code", :limit => 30
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table :skm_channels_tl, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "channel_id", :limit => 22, :null => false
      t.string "name", :limit => 30, :null => false
      t.string "description", :limit => 150
      t.string "language", :limit => 30
      t.string "source_lang", :limit => 30
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    execute('CREATE OR REPLACE VIEW skm_channels_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM skm_channels  t,skm_channels_tl tl
                                                 WHERE t.id = tl.channel_id')

    create_table :skm_channel_groups, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "channel_id", :limit => 22, :null => false
      t.string "group_id", :limit => 22, :null => false
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table :skm_channel_columns, :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "channel_id", :limit => 22, :null => false
      t.string "column_id", :limit => 22, :null => false
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    execute('DROP VIEW skm_channels_vl')
    drop_table :skm_channels
    drop_table :skm_channels_tl
    drop_table :skm_channel_groups
    drop_table :skm_channel_columns
  end
end
