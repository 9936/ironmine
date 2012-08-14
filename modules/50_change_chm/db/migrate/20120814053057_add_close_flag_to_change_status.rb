class AddCloseFlagToChangeStatus < ActiveRecord::Migration
  def change
    add_column :chm_change_statuses, :close_flag, :string ,:default=>'N', :limit => 1, :null => false,:after=> :default_flag
  end
end
