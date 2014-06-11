class AddBranchToNdm < ActiveRecord::Migration
  def change
    add_column :ndm_dev_managements, :branch, :string, :limit => 30, :after => :no
  end
end
