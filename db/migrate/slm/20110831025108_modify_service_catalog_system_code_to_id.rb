class ModifyServiceCatalogSystemCodeToId < ActiveRecord::Migration
  def self.up
    execute("DROP VIEW slm_service_catalogs_vl")
    rename_column :slm_service_catalogs, :external_system_code, :external_system_id
    change_column :slm_service_catalogs, :external_system_id, :string, :limit => 22
    execute('CREATE OR REPLACE VIEW slm_service_catalogs_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM slm_service_catalogs  t,slm_service_catalogs_tl tl
                                             WHERE t.id = tl.service_catalog_id')
  end

  def self.down
    execute("DROP VIEW slm_service_catalogs_vl")
    rename_column :slm_service_catalogs, :external_system_id, :external_system_code
    change_column :slm_service_catalogs, :external_system_code, :string, :limit => 22
    execute('CREATE OR REPLACE VIEW slm_service_catalogs_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM slm_service_catalogs  t,slm_service_catalogs_tl tl
                                             WHERE t.id = tl.service_catalog_id')
  end
end
