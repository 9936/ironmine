class ChangeRequestApproveStatus < ActiveRecord::Migration
  def up
    change_column :chm_change_requests,:approve_flag,  :string,:limit=>30
    rename_column :chm_change_requests,:approve_flag,:approve_status
  end

  def down
    change_column :chm_change_requests,:approve_status,  :string,:limit=>1
    rename_column :chm_change_requests,:approve_status ,:approve_flag
  end
end
