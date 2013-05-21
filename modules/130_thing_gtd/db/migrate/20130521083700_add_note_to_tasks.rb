class AddNoteToTasks < ActiveRecord::Migration
  def change
    add_column :gtd_tasks, :note, :text, :after => :member_type
  end
end
