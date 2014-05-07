class FixNdmTableId < ActiveRecord::Migration
  def up
    change_column :dem_dev_managements, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
  end
end
