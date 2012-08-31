class AddSourceFileNameToAttachment < ActiveRecord::Migration
  def up
    add_column :irm_attachment_versions, :source_file_name, :string, :limit => 150, :after => :source_id
    add_column :irm_attachments, :source_file_name, :string, :limit => 150, :after => :file_type
  end

  def down
    remove_column :irm_attachment_versions, :source_file_name
    remove_column :irm_attachments, :source_file_name
  end
end
