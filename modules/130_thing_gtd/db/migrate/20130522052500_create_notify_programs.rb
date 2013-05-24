class CreateNotifyPrograms < ActiveRecord::Migration
  def change
    create_table :gtd_notify_programs, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "notify_type",:limit => 20, :default => "EMAIL"
      t.string "wf_mail_alert_id", :limit => 22, :collate => "utf8_bin"
      t.text "incident_request_hash"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :gtd_notify_programs, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :gtd_notify_programs_tl, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "notify_program_id", :limit => 22, :collate => "utf8_bin"
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
    change_column :gtd_notify_programs_tl, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "gtd_notify_programs_tl", ["notify_program_id", "language"], :name => "GTD_NOTIFT_PROGRAMS_TL_U1", :unique => true
    add_index "gtd_notify_programs_tl", ["notify_program_id"], :name => "GTD_NOTIFT_PROGRAMS_TL_N1"

    execute('CREATE OR REPLACE VIEW gtd_notify_programs_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                     FROM gtd_notify_programs t,gtd_notify_programs_tl tl
                                                     WHERE t.id = tl.notify_program_id')
  end
end
