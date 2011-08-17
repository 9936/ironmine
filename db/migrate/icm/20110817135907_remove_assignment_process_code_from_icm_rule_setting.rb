class RemoveAssignmentProcessCodeFromIcmRuleSetting < ActiveRecord::Migration
  def self.up
    remove_column :icm_rule_settings, :assignment_process_code
  end

  def self.down
    add_column :icm_rule_settings, :assignment_process_code, :string, :limit => 30
  end
end
