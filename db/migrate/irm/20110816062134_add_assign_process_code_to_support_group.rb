class AddAssignProcessCodeToSupportGroup < ActiveRecord::Migration
  def self.up
    add_column :irm_support_groups, :assignment_process_code, :string, :limit => 30, :after => :group_code
  end

  def self.down
    remove_column :irm_support_groups, :assignment_process_code
  end
end
