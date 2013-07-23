class AddColumnToTarget < ActiveRecord::Migration
  def change
    add_column :emw_monitor_targets, :shell_conn, :string, :limit => 22, :collate => "utf8_bin", :after => "monitor_program_id"
    add_column :emw_monitor_targets, :sql_conn, :string, :limit => 22, :collate => "utf8_bin", :after => "monitor_program_id"
  end
end
