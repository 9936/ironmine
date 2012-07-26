class AddNoteToSkmEntryApprovalPeople < ActiveRecord::Migration
  def up
    add_column :skm_entry_approval_people, :note, :text, :default => '', :after => :approval_flag
  end

  def down
    remove_column :skm_entry_approval_people, :note
  end
end
