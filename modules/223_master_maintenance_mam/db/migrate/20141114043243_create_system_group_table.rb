class CreateSystemGroupTable < ActiveRecord::Migration
  def up
    rename_column :mam_system_groups, :group_id, :support_group_id
  end

  def down
  end
end
