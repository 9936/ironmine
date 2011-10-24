class ChangeBoForLov < ActiveRecord::Migration
  def up
    change_column :irm_business_objects,:workflow_flag,:string,:limit=>1,:default=>"N",:after=>:multilingual_flag
    #rename_column :irm_business_objects,:bo_table_name,:table_name
    #rename_column :irm_business_objects,:bo_model_name,:model_name
    #rename_column :irm_business_objects,:business_object_code,:code
    add_column :irm_business_objects,:report_flag,:string,:limit=>1,:default=>"N",:after=>:multilingual_flag
    add_column :irm_business_objects,:standard_flag,:string,:limit=>1,:default=>"Y",:after=>:multilingual_flag

    execute('CREATE OR REPLACE VIEW irm_business_objects_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_business_objects  t,irm_business_objects_tl tl
                                             WHERE t.id = tl.business_object_id')

    add_column :irm_object_attributes,:business_object_id,:string,:limit=>22,:after=>:opu_id
    add_column :irm_object_attributes,:category,:string,:limit=>30,:after=>:field_type

    rename_column :irm_object_attributes,:nullable_flag,:data_null_flag
    rename_column :irm_object_attributes,:key_type,:data_key_type
    rename_column :irm_object_attributes,:default_value,:data_default_value
    rename_column :irm_object_attributes,:extra_info,:data_extra_info

    add_column :irm_object_attributes,:relation_bo_id,:string,:limit=>22,:after=>:relation_bo_code
    rename_column :irm_object_attributes,:relation_table_alias_name,:relation_table_alias
    rename_column :irm_object_attributes,:exists_relation_flag,:relation_exists_flag
    add_column :irm_object_attributes,:relation_object_attribute_id,:string,:limit=>22,:after=>:relation_column
    rename_column :irm_object_attributes,:where_clause,:relation_where_clause

    add_column :irm_object_attributes,:pick_list_code,:string,:limit=>30,:after=>:lov_code

    rename_column :irm_object_attributes,:approval_page_field_flag,:approve_flag
    change_column :irm_object_attributes,:approve_flag,:string,:limit=>1,:default=>"N",:after=>:data_extra_info
    change_column :irm_object_attributes,:filter_flag,:string,:limit=>1,:default=>"N",:after=>:data_extra_info
    change_column :irm_object_attributes,:person_flag,:string,:limit=>1,:default=>"N",:after=>:data_extra_info
    change_column :irm_object_attributes,:update_flag,:string,:limit=>1,:default=>"N",:after=>:data_extra_info
    add_column :irm_object_attributes,:required_flag,:string,:limit=>1,:default=>"N",:after=>:data_extra_info
    add_column :irm_object_attributes,:label_flag,:string,:limit=>1,:default=>"N",:after=>:data_extra_info

    sleep(10)
    bo_code_ids = {}
    Irm::ObjectAttribute.all.each do |oa|
      unless bo_code_ids[oa.business_object_code]
        bo_id = Irm::BusinessObject.where(:business_object_code=>oa.business_object_code).first.id
        bo_code_ids[oa.business_object_code] = bo_id
      end
      oa.update_attribute(:business_object_id,bo_code_ids[oa.business_object_code])
    end

    remove_column :irm_object_attributes,:business_object_code

    execute('CREATE OR REPLACE VIEW irm_object_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_object_attributes  t,irm_object_attributes_tl tl
                                             WHERE t.id = tl.object_attribute_id')
  end

  def down
  end
end
