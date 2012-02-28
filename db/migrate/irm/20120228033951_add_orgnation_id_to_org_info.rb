class AddOrgnationIdToOrgInfo < ActiveRecord::Migration
  def up
      add_column :irm_organization_infos,:organization_id,:string,:limit => 22 , :collate=>"utf8_bin",:after=>:attachment_id
      add_index :irm_organization_infos, :organization_id
  end

  def down
    remove_column :irm_organization_infos,:organization_id
    remove_index :irm_organization_infos, :organization_id
  end
end
