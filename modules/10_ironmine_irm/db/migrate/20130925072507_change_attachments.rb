class ChangeAttachments < ActiveRecord::Migration
  def change
    add_column "irm_attachments", :folder_id, :string, :limit => 22, :null => true, :after=> :access_type
  end
end
