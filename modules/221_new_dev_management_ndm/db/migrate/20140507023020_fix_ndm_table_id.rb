class FixNdmTableId < ActiveRecord::Migration
  def up
    change_column :ndm_dev_managements, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
  end
end
