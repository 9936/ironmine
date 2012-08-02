class ConfigClassAndAttributeVl < ActiveRecord::Migration
  def up
    change_column :com_config_class_explosions, "id", :string,:limit=>22, :collate=>"utf8_bin"

    execute('CREATE OR REPLACE VIEW com_config_classes_attributes_vl AS
        select ca.id,ca.code, ca.config_class_id,ca.input_type,ca.input_value,ca.regular,ca.required_flag from com_config_attributes ca
        UNION ALL
        select ca.id,ca.code, cce.config_class_id,ca.input_type,ca.input_value,ca.regular,ca.required_flag from com_config_class_explosions cce,com_config_attributes ca WHERE ca.config_class_id = cce.parent_id')

  end

  def down
  end
end
