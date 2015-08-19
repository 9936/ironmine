class CreateFmAttachmentCountersTable < ActiveRecord::Migration
  def up
    create_table :fm_attachment_counters, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "status_code", :limit => 30, :null => false
      t.string "version_id", :limit => 22, :collate => "utf8_bin"
      t.string "download_by", :limit => 22, :collate => "utf8_bin"
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :fm_attachment_counters, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
    drop_table :fm_attachment_counters
  end
end

