class CreateFmAttachmentMembersTable < ActiveRecord::Migration
  def up
    create_table :fm_attachment_members, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "attachment_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "member_type", :limit => 30, :null => false
      t.string   "member_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :fm_attachment_members, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
  end
end
