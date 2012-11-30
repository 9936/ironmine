class AddObjectAttributeCuxField < ActiveRecord::Migration
  def up
    remove_column :irm_object_attributes, :relation_bo_code
    remove_column :irm_object_attributes, :relation_column
    remove_column :irm_object_attributes, :relation_where_clause
    remove_column :irm_object_attributes, :relation_alias_ref_id
    remove_column :irm_object_attributes, :lov_code
    remove_column :irm_object_attributes, :pick_list_code
    add_column :irm_object_attributes, :pick_list_options, :text, :after => :data_extra_info
    add_column :irm_object_attributes, :display_sequence, :integer, :default => 10, :after => :category
    add_column :irm_object_attributes,:external_system_id ,:string,:limit => 22,:collate => "utf8_bin",:after=>:category

    add_column :irm_object_attributes, :all_system_flag, :string,:limit=>1, :default => "N", :after => :label_flag

    execute('CREATE OR REPLACE VIEW irm_object_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_object_attributes  t,irm_object_attributes_tl tl
                                                 WHERE t.id = tl.object_attribute_id')


    create_table "irm_object_attribute_systems", :force => true do |t|
      t.string "opu_id", :limit => 22, :null => false
      t.string "object_attribute_id", :limit => 22,:null => false, :collate => "utf8_bin"
      t.string "external_system_id", :limit => 22,:null => false, :collate => "utf8_bin"
      t.integer "display_sequence", :default => 10
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "irm_object_attribute_systems", ["object_attribute_id", "external_system_id"], :name => "IRM_OBJECT_ATTRIBUTE_SYSTEMS_U1", :unique => true


    add_column :irm_business_objects,:custom_flag,:string,:limit=>1,:default=>"N",:after=>"data_access_flag"
  end

  def down
    add_column :irm_object_attributes, :relation_bo_code, :string, :limit => 30
    add_column :irm_object_attributes, :relation_column, :string, :limit => 30
    add_column :irm_object_attributes, :relation_where_clause, :string, :limit => 30
    add_column :irm_object_attributes, :relation_alias_ref_id, :string, :limit => 30
    add_column :irm_object_attributes, :lov_code, :string, :limit => 30
    add_column :irm_object_attributes, :pick_list_code, :string, :limit => 30
    remove_column :irm_object_attributes, :display_sequence
    remove_column :irm_object_attributes, :pick_list_options
    remove_column :irm_object_attributes, :external_system_id
    remove_column :irm_object_attributes, :all_system_flag
    execute('CREATE OR REPLACE VIEW irm_object_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_object_attributes  t,irm_object_attributes_tl tl
                                                 WHERE t.id = tl.object_attribute_id')

    drop_table :irm_object_attribute_systems

    remove_column :irm_business_objects,:custom_flag

  end
end
