class AddParentIdToSupportGroup < ActiveRecord::Migration
  def self.up
    add_column :irm_support_groups, :parent_group_id, :string, :limit => 22, :after => :group_code
  end

  def self.down
    remove_column :irm_support_groups, :parent_group_id
  end
end
