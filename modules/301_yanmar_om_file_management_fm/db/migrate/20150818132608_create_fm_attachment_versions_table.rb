class CreateFmAttachmentVersionsTable < ActiveRecord::Migration
  def up
    create_table "fm_attachment_versions", :force => true do |t|
      t.string   "opu_id",            :limit => 22,                   :null => false
      t.string   "attachment_id",     :limit => 22,                   :null => false
      t.string   "description",       :limit => 240
      t.string   "private_flag",      :limit => 1
      t.string   "image_flag",        :limit => 1,   :default => "Y"
      t.string   "category_id",       :limit => 22
      t.string   "source_type",       :limit => 30
      t.string   "source_id",         :limit => 22
      t.string   "source_file_name",  :limit => 150
      t.string   "data_file_name",    :limit => 150
      t.string   "data_content_type", :limit => 30
      t.integer  "data_file_size"
      t.datetime "data_updated_at"
      t.integer  "download_count",    :default => 0
      t.string   "status_code",    :limit => 30,  :default => "ENABLED", :null => false
      t.string   "created_by",        :limit => 22
      t.string   "updated_by",        :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :fm_attachment_versions, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
  end
end
