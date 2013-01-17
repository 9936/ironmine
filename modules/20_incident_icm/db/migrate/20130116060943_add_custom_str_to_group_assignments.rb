class AddCustomStrToGroupAssignments < ActiveRecord::Migration
  def change
    add_column :icm_group_assignments, :custom_str, :text, :after => :source_id, :default => ''
  end
end
