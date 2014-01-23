class ChangeSomSendSummary < ActiveRecord::Migration
  def up
    add_column :som_send_summaries, :communicate_interval,:integer,:default=>20,:after=>:summary_enable_flag
    add_column :som_send_summaries, :summary_type,:string,:limit=>30,:after=>:summary_enable_flag
  end

  def down
    remove_column :som_send_summaries, :communicate_interval
    remove_column :som_send_summaries, :summary_type
  end
end
