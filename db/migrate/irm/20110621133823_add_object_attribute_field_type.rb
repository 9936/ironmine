class AddObjectAttributeFieldType < ActiveRecord::Migration
  def self.up
    add_column(:irm_object_attributes,:field_type,:string,:limit=>30,:default=>"CUSTOMED_FIELD",:after=>:attribute_type)
    execute('CREATE OR REPLACE VIEW irm_object_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_object_attributes  t,irm_object_attributes_tl tl
                                             WHERE t.id = tl.object_attribute_id')
  end

  def self.down
    remove_column(:irm_object_attributes,:field_type)
    execute('CREATE OR REPLACE VIEW irm_object_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_object_attributes  t,irm_object_attributes_tl tl
                                             WHERE t.id = tl.object_attribute_id')
  end
end
