class AddParentIdToConfigClass < ActiveRecord::Migration
  def up
    add_column :com_config_classes, "parent_id", :string, :limit => 22 , :collate=>"utf8_bin",:after => "leaf_flag"
  end
  def down
    remove_column :com_config_classes, "parent_id"
  end
end
