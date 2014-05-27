class AddDevStatusToDevManagement < ActiveRecord::Migration
  def change
    add_column :ndm_dev_managements, :dev_status, :string, :limit => 30, :after => :priority
  end
end
