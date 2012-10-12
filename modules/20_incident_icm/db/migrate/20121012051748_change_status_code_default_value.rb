class ChangeStatusCodeDefaultValue < ActiveRecord::Migration
  def up
    change_column :icm_assign_rules, "status_code", :string, :limit => 30, :default => "DISABLED",:null => false
  end

  def down
    change_column :icm_assign_rules, "status_code", :string, :limit => 30, :default => "ENABLED",:null => false
  end
end
