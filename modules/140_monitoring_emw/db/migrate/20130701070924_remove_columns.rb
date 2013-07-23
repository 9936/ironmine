class RemoveColumns < ActiveRecord::Migration
  def change
    remove_column "emw_monitor_programs", :time_mode
    remove_column "emw_monitor_programs", :start_at
    remove_column "emw_monitor_programs", :end_at
    remove_column "emw_monitor_programs", :start_time
    remove_column "emw_monitor_programs", :repeat_type
  end

end
