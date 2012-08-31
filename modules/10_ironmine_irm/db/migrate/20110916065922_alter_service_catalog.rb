class AlterServiceCatalog < ActiveRecord::Migration
  def change
    remove_column :slm_service_catalogs,:service_category_code
    add_column :slm_service_catalogs,:service_category_id,:string,:limit=>22,:after=>:catalog_code
    remove_column  :slm_service_catalogs,:external_system_id
    remove_column :slm_service_catalogs,:slm_code
    add_column :slm_service_catalogs,:slm_id,:string,:limit=>22,:after=> :catalog_code
    add_column :slm_service_catalogs,:parent_catalog_id,:string,:limit=>22,:after=>:catalog_code
    remove_column :slm_service_members ,:service_company_id
    remove_column :slm_service_members ,:service_organization_id
    remove_column :slm_service_members ,:service_department_id
    remove_column :slm_service_members ,:service_person_id
    remove_column :slm_service_members ,:service_contract_id
    remove_column :slm_service_members ,:description
    add_column :slm_service_members ,:external_system_id,:string,:limit=>22,:after=>:service_catalog_id
    execute('CREATE OR REPLACE VIEW slm_service_catalogs_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM slm_service_catalogs  t,slm_service_catalogs_tl tl
                                             WHERE t.id = tl.service_catalog_id')

    create_table "slm_service_catalog_explosions", :force => true do |t|
      t.string   "parent_service_catalog_id",        :limit => 22,                        :null => false
      t.string   "direct_parent_service_catalog_id", :limit => 22,                        :null => false
      t.string   "service_catalog_id",               :limit => 22,                        :null => false
      t.string   "opu_id",                 :limit => 22,                        :null => false
      t.string   "status_code",            :limit => 30, :default => "ENABLED"
      t.string   "created_by",             :limit => 22,                        :null => false
      t.string   "updated_by",             :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :slm_service_catalog_explosions, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end

end
