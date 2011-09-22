class ChangeAttachmentCategoryToStringFromInt < ActiveRecord::Migration
  def up
    change_column :irm_attachments, :file_category, :string, :limit => 22
  end

  def down
    change_column :irm_attachments, :file_category, :integer
  end
end
