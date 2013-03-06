class ChangeCalendarItems < ActiveRecord::Migration
  def up
    drop_table :slm_calendar_items
    drop_table :slm_calendar_items_tl
    execute('DROP VIEW slm_calendar_items_vl')

    create_table :slm_calendar_items, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "calendar_id", :limit => 22, :collate => "utf8_bin"
      t.string "calendar_year"
      t.string "start_at"
      t.string "end_at"
      t.text   "calendar_obj"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_calendar_items, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "slm_calendar_items", ["calendar_id", "calendar_year"], :name => "SLM_CALENDAR_YEAR_N1"
  end

  def down
    drop_table :slm_calendar_items

    create_table :slm_calendar_items, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "calendar_id", :limit => 22, :collate => "utf8_bin"
      t.datetime "start_at"
      t.datetime "end_at"
      t.text    "time_mode"
      t.datetime "deadline"
      t.string "relation_type", :limit => 30, :null => false
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_calendar_items, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :slm_calendar_items_tl, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "calendar_item_id", :limit => 22, :collate => "utf8_bin"
      t.string "language", :limit => 30, :null => false
      t.string "name", :limit => 150
      t.string "description", :limit => 240
      t.string "source_lang", :limit => 30, :null => false
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_calendar_items_tl, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "slm_calendar_items_tl", ["calendar_item_id", "language"], :name => "SLM_CALENDAR_ITEMS_TL_U1", :unique => true
    add_index "slm_calendar_items_tl", ["calendar_item_id"], :name => "SLM_CALENDAR_ITEMS_TL_N1"

    execute('CREATE OR REPLACE VIEW slm_calendar_items_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
             FROM slm_calendar_items t,slm_calendar_items_tl tl WHERE t.id = tl.calendar_item_id')
  end
end
