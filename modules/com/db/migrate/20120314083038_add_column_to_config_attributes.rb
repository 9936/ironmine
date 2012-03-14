class AddColumnToConfigAttributes < ActiveRecord::Migration
  def up
    add_column :com_config_attributes, "input_value", :string,:limit=>200
    add_column :com_config_attributes, "regular", :string,:limit=>100
    add_column :com_config_attributes, "required_flag",  :limit => 1, :null => false,:default=>"N"
  end
  def down
    add_column :com_config_attributes, "input_value"
    add_column :com_config_attributes, "regular"
    add_column :com_config_attributes, "required_flag"
  end
end
