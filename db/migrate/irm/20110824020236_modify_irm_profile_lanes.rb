class ModifyIrmProfileLanes < ActiveRecord::Migration
  def self.up
    remove_column :irm_profile_lanes, :kanban_id
    remove_column :irm_profile_lanes, :profile_id
    add_column :irm_profile_lanes, :profile_kanban_id, :string, :limit => 22, :after => :company_id
  end

  def self.down
    add_column :irm_profile_lanes, :kanban_id, :string, :limit => 22, :after => :company_id
    add_column :irm_profile_lanes, :profile_id, :string, :limit => 22, :after => :company_id
    remove_column :irm_profile_lanes, :profile_kanban_id
  end
end
