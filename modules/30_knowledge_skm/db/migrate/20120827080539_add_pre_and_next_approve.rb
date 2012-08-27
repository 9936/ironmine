class AddPreAndNextApprove < ActiveRecord::Migration
  def up
    add_column :skm_entry_approval_people, :pre_approval_id, :string, :limit => 22,  :default => '', :after => :approval_flag
    add_column :skm_entry_approval_people, :next_approval_id, :string, :limit => 22,  :default => '', :after => :pre_approval_id
  end

  def down
    remove_column :skm_entry_approval_people, :pre_approval_id
    remove_column :skm_entry_approval_people, :next_approval_id
  end
end
