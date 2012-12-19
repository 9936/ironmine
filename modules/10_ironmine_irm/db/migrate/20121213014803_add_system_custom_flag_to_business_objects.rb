class AddSystemCustomFlagToBusinessObjects < ActiveRecord::Migration
  def up
    add_column :irm_business_objects,:system_custom_flag,:string,:limit=>1,:default=>"N",:after=>"custom_flag"
    execute('CREATE OR REPLACE VIEW irm_object_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_object_attributes  t,irm_object_attributes_tl tl
                                                 WHERE t.id = tl.object_attribute_id')
  end

  def down
    remove_column :irm_business_objects,:system_custom_flag
    execute('CREATE OR REPLACE VIEW irm_object_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_object_attributes  t,irm_object_attributes_tl tl
                                                 WHERE t.id = tl.object_attribute_id')
  end
end
