class AddAdminFlagToGroupMembers < ActiveRecord::Migration
  def change
    add_column :irm_group_members, :admin_flag, :string, :default => "N",:limit=>1, :after => :opu_id
  end
end
