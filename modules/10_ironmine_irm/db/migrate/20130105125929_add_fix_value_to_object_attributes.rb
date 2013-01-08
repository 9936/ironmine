class AddFixValueToObjectAttributes < ActiveRecord::Migration
  def change
    add_column :irm_object_attributes, :required_default_value, :string, :after=> :required_flag
  end
end
