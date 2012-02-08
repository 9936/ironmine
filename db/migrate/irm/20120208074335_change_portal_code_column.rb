class ChangePortalCodeColumn < ActiveRecord::Migration
  def up
    change_column :irm_portlet_configs, "portal_code", :string,:limit=>22, :null => true
  end

  def down
  end
end
