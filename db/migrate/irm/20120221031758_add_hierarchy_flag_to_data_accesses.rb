class AddHierarchyFlagToDataAccesses < ActiveRecord::Migration
  def up
    add_column :irm_data_accesses,:hierarchy_access_flag,:string,:limit=>1,:default=>"N",:after=>:access_level
  end

  def down
    remove_column :irm_data_accesses,:hierarchy_access_flag
  end
end
