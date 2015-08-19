class CreateFmAttachmentsTable < ActiveRecord::Migration
  def up
    create_table "fm_attachments", :force => true do |t|
      t.string   "opu_id",            :limit => 22,  :null => false
      t.string   "description",       :limit => 240
      t.string   "access_type",       :limit => 22, :default => "PRIVATE"
      t.string   "folder_id",         :limit => 22, :null => true
      t.string   "latest_version_id", :limit => 22
      t.string   "file_name",         :limit => 150
      t.integer  "file_category"
      t.integer  "file_size"
      t.string   "file_type",         :limit => 30
      t.string   "source_file_name",  :limit => 150
      t.string   "status_code",       :limit => 30
      t.string   "created_by",        :limit => 22
      t.string   "updated_by",        :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :fm_attachments, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
  end
end
