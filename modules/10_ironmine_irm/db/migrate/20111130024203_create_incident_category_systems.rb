class CreateIncidentCategorySystems < ActiveRecord::Migration
  def up
    create_table "icm_incident_category_systems", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "incident_category_id", :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "external_system_id", :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_incident_category_systems, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "icm_incident_category_systems", ["incident_category_id","external_system_id"], :name => "ICM_INCIDENT_CATEGORY_SYSTEMS_N1"


    remove_column :icm_incident_categories,:external_system_id

    execute('CREATE OR REPLACE VIEW icm_incident_categories_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM icm_incident_categories t,icm_incident_categories_tl tl
                         WHERE t.id = tl.incident_category_id')
  end

  def down
    drop_table  :icm_incident_category_systems
    add_column :icm_incident_categories,:external_system_id , :limit => 22, :null => false, :collate=>"utf8_bin"
    execute('CREATE OR REPLACE VIEW icm_incident_categories_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM icm_incident_categories t,icm_incident_categories_tl tl
                         WHERE t.id = tl.incident_category_id')
  end
end
