class CreateCalendars < ActiveRecord::Migration
  def up
    create_table :slm_calendars, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "external_system_id", :limit => 22, :collate => "utf8_bin"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_calendars, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :slm_calendars_tl, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "calendar_id", :limit => 22, :collate => "utf8_bin"
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
    change_column :slm_calendars_tl, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "slm_calendars_tl", ["calendar_id", "language"], :name => "SLM_CALENDARS_TL_U1", :unique => true
    add_index "slm_calendars_tl", ["calendar_id"], :name => "SLM_CALENDARS_TL_N1"

    execute('CREATE OR REPLACE VIEW slm_calendars_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
             FROM slm_calendars t,slm_calendars_tl tl WHERE t.id = tl.calendar_id')
  end

  def down
    drop_table :slm_calendars
    drop_table :slm_calendars_tl
    execute('DROP VIEW slm_calendars_vl')
  end
end
