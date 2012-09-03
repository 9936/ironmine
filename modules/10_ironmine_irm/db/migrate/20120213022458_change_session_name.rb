class ChangeSessionName < ActiveRecord::Migration
  def up
    drop_table :irm_session_times
    create_table :irm_session_timeouts do |t|
      t.string   "opu_id",            :limit => 22 , :collate=>"utf8_bin"
      t.string   "time_out",          :limit => 30
      t.string   "status_code",       :limit => 30, :null => false
      t.string   "created_by",       :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    drop_table :irm_session_timeouts
    create_table :irm_session_times do |t|
      t.string   "opu_id",            :limit => 22 , :collate=>"utf8_bin"
      t.string   "time_out",          :limit => 30
      t.string   "status_code",       :limit => 30, :null => false
      t.string   "created_by",       :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end


