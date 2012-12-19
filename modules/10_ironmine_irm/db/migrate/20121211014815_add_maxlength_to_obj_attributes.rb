class AddMaxlengthToObjAttributes < ActiveRecord::Migration
  def change
    add_column :irm_object_attributes, "min_length", :integer, :default => 0, :null => false, :after => "required_flag"
    add_column :irm_object_attributes, "max_length", :integer, :default => 0, :null => false, :after => "min_length"
    execute('CREATE OR REPLACE VIEW irm_object_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_object_attributes  t,irm_object_attributes_tl tl
                                                 WHERE t.id = tl.object_attribute_id')
  end
end
