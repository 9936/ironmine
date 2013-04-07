class AddCountToAttachmentVersion < ActiveRecord::Migration
  def up
    add_column :irm_attachment_versions, :download_count, :integer, :default => 0, :after => :data_updated_at
  end

  def down
    remove_column :irm_attachment_versions, :download_count
  end
end
