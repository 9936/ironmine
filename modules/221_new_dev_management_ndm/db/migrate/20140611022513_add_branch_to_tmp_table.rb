class AddBranchToTmpTable < ActiveRecord::Migration
  def change
    add_column :ndm_tmp_dev_managements, :branch, :string, :limit => 30, :after => :no
  end
end
