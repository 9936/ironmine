class ChangeAssignment < ActiveRecord::Migration
  def up
    rename_column :icm_group_assignments, "support_group_id", "assign_rule_id"
  end

  def down
    rename_column :icm_group_assignments, "assign_rule_id", "support_group_id"
  end
end
