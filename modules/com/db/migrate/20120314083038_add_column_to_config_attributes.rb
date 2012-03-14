class AddColumnToConfigAttributes < ActiveRecord::Migration
  def up
    add_column :com_config_attributes, "input_value", :string,:limit=>200,:after => "input_type"
    add_column :com_config_attributes, "regular", :string,:limit=>100,:after => "input_value"
    add_column :com_config_attributes, "required_flag", :string,:limit => 1, :null => false,:default=>"N",:after => "regular"
  end
  def down
    remove_column :com_config_attributes, "input_value"
    remove_column :com_config_attributes, "regular"
    remove_column :com_config_attributes, "required_flag"
  end
end
