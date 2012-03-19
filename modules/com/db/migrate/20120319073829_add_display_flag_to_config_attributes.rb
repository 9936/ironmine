class AddDisplayFlagToConfigAttributes < ActiveRecord::Migration
  def change
    add_column :com_config_attributes, "display_flag", :string,:limit => 1, :null => false,:default=>"N",:after => "required_flag"

    execute('CREATE OR REPLACE VIEW com_config_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
             FROM com_config_attributes t,com_config_attributes_tl tl
             WHERE t.id = tl.config_attribute_id')
  end
end
