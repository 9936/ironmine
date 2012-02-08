class AddPortalLayoutIdToirmPortletConfigs < ActiveRecord::Migration
  def up
     add_column :irm_portlet_configs, :portal_layout_id, :string , :limit => 22,:collate=>"utf8_bin",:after=> :config
  end

  def down
    remove_column :irm_portlet_configs, :portal_layout_id
  end
end
