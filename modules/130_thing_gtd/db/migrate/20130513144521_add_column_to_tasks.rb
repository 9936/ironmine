class AddColumnToTasks < ActiveRecord::Migration
  def change
    add_column :gtd_tasks, :access_type, :string, :limit => 22, :after => :duration
    add_column :gtd_tasks, :member_type, :string, :limit => 32, :after => :duration
    add_column :gtd_tasks, :repeat, :string, :limit => 1, :after => :rule, :default => 'Y'
  end
end
