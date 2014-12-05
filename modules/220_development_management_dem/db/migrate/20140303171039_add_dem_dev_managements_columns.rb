class AddDemDevManagementsColumns < ActiveRecord::Migration
  def up
    add_column :dem_dev_managements, :develop_id, :string, :limit => 22
    add_column :dem_dev_managements, :require_date, :date
    add_column :dem_dev_managements, :risk_class, :string, :limit => 30
  end

  def down
  end
end
