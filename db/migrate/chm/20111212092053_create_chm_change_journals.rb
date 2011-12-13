class CreateChmChangeJournals < ActiveRecord::Migration
  def up
    create_table "chm_change_journals", :force => true do |t|
      t.string   "opu_id",              :limit => 22
      t.string   "change_request_id",   :limit => 22, :null => false
      t.string   "reply_type",          :limit => 30
      t.string   "replied_by",          :limit => 22, :null => false
      t.text     "message_body",                      :null => false
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22
      t.string   "updated_by",          :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :chm_change_journals, "id", :string,:limit=>22, :collate=>"utf8_bin"


    add_index "chm_change_journals", ["change_request_id"], :name => "CHM_CHANGE_JOURNALS_N1"
    add_index "chm_change_journals", ["replied_by"], :name => "CHM_CHANGE_JOURNALS_N2"
  end

  def down
    drop_table :chm_change_journals
  end
end
