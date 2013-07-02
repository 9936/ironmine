class RenameTimeTrigger < ActiveRecord::Migration
  def change
    rename_column "irm_time_triggers", :target_id, :source_id
    rename_column "irm_time_triggers", :target_type, :source_type
    add_column "irm_time_triggers", :repeat_type, :string, :limit => 10, :after => :schedule_days
  end
end
