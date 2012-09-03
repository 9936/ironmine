class CreateDataAccesses < ActiveRecord::Migration
  def up
    create_table "irm_data_accesses", :force => true do |t|
      t.string   "opu_id",              :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "organization_id",     :limit => 22, :collate=>"utf8_bin"
      t.string   "business_object_id",  :limit => 22, :collate=>"utf8_bin"
      t.string   "access_level",        :limit => 30, :null => false
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_data_accesses, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "irm_data_accesses", ["opu_id","organization_id","business_object_id"],:unique=>true, :name => "IRM_DATA_ACCESSES_U1"


    add_column :irm_business_objects,:data_access_flag,:string,:limit=>1,:default=>"N",:after=>:workflow_flag

    execute('CREATE OR REPLACE VIEW irm_business_objects_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_business_objects  t,irm_business_objects_tl tl
                                             WHERE t.id = tl.business_object_id')

  end


  def down
    drop_table :irm_data_accesses
    remove_column :irm_business_objects,:data_access_flag

    execute('CREATE OR REPLACE VIEW irm_business_objects_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_business_objects  t,irm_business_objects_tl tl
                                             WHERE t.id = tl.business_object_id')
  end
end
