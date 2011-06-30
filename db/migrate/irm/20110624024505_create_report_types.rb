class CreateReportTypes < ActiveRecord::Migration
  def self.up
    create_table :irm_report_types,:force=>true do |t|
      t.string :category_id,:limit=>22, :null => false
      t.string :business_object_id,:limit=>22, :null => false
      t.string :code,:limit=>30, :null => false
      t.string   "status_code", :limit => 30,  :null => false
      t.string   "created_by",:limit=>22,:null=>false
      t.string   "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_types, :id, :string,:limit=>22, :null => false

    add_index "irm_report_types", "code",:unique=>true, :name => "IRM_REPORT_TYPE_U1"

    create_table :irm_report_types_tl, :force => true do |t|
      t.string  "report_type_id",     :limit=>22,:null=>false
      t.string   "language",          :limit => 30,  :null => false
      t.string   "name",              :limit => 150, :null => false
      t.string   "description",       :limit => 240
      t.string   "source_lang",       :limit => 30,  :null => false
      t.string   "status_code",       :limit => 30,  :null => false
      t.string  "created_by",:limit=>22,:null=>false
      t.string  "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_types_tl, :id, :string,:limit=>22, :null => false

    add_index "irm_report_types_tl", ["report_type_id", "language"],:unique=>true, :name => "IRM_REPORT_TYPES_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_report_types_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_report_types  t,irm_report_types_tl tl
                                           WHERE t.id = tl.report_type_id')

    create_table :irm_report_type_objects,:force=>true do |t|
      t.string :report_type_id,:limit=>22, :null => false
      t.string :business_object_id,:limit=>22, :null => false
      t.string :object_sequence,:limit=>1, :null => false
      t.string :relationship_type,:limit=>30, :null => false
      t.string   "status_code", :limit => 30,  :null => false
      t.string   "created_by",:limit=>22,:null=>false
      t.string   "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_type_objects, :id, :string,:limit=>22, :null => false

    add_index "irm_report_type_objects", ["report_type_id","business_object_id"],:unique=>true, :name => "IRM_REPORT_TYPE_OBJECTS_U1"
    add_index "irm_report_type_objects", "report_type_id",:name => "IRM_REPORT_TYPE_OBJECTS_N1"

    create_table :irm_report_type_sections,:force=>true do |t|
      t.string :report_type_id,:limit=>22, :null => false
      t.string :name,:limit=>150, :null => false
      t.integer :section_sequence,:null => false
      t.string   "status_code", :limit => 30,  :null => false
      t.string   "created_by",:limit=>22,:null=>false
      t.string   "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_type_sections, :id, :string,:limit=>22, :null => false

    add_index "irm_report_type_sections", "report_type_id",:name => "IRM_REPORT_TYPE_SECTIONS_N1"

    create_table :irm_report_type_fields,:force=>true do |t|
      t.string :section_id,:limit=>22, :null => false
      t.string :object_attribute_id,:limit=>22, :null => false
      t.string :default_selection_flag,:limit=>1, :null => false,:default=>"N"
      t.string   "status_code", :limit => 30,  :null => false
      t.string   "created_by",:limit=>22,:null=>false
      t.string   "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_type_fields, :id, :string,:limit=>22, :null => false

    add_index "irm_report_type_fields", "section_id",:name => "IRM_REPORT_TYPE_FIELDS_N1"

  end

  def self.down
    drop_table :irm_report_types
    drop_table :irm_report_types_tl
    execute('drop view irm_report_types_vl')
    drop_table :irm_report_type_objects
    drop_table :irm_report_type_sections
    drop_table :irm_report_type_fields
  end
end
