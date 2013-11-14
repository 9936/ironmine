class CreateIrmAttachmentFolders < ActiveRecord::Migration
  def change
    create_table "irm_attachment_folders" do |t|
      t.string :name, :limit => 150, :null => false
      t.string :description, :limit => 240
      t.string :parent_id, :limit => 22, :null => false , :collate => "utf8_bin"
      t.string  :status_code, :limit => 30, :default => "ENABLED"
      t.string :created_by, :limit => 22, :null => false , :collate => "utf8_bin"
      t.string :updated_by, :limit => 22, :null => false , :collate => "utf8_bin"
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
    change_column :irm_attachment_folders, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
