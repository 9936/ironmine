class CreateIncidentCategories < ActiveRecord::Migration
  def change
    create_table "icm_incident_categories", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code", :limit => 60, :null => false
      t.string   "external_system_id", :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_incident_categories, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "icm_incident_categories", ["code"], :name => "ICM_INCIDENT_CATEGORIES_U1"

    create_table "icm_incident_categories_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "incident_category_id", :limit => 22, :collate=>"utf8_bin"
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :icm_incident_categories_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "icm_incident_categories_tl", ["incident_category_id", "language"], :name => "ICM_INCIDENT_CATEGORIES_TL_U1", :unique => true
    add_index "icm_incident_categories_tl", ["incident_category_id"], :name => "ICM_INCIDENT_CATEGORIES_TL_N1"

    execute('CREATE OR REPLACE VIEW icm_incident_categories_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM icm_incident_categories t,icm_incident_categories_tl tl
                         WHERE t.id = tl.incident_category_id')


    create_table "icm_incident_sub_categories", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code", :limit => 60, :null => false
      t.string   "incident_category_id", :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_incident_sub_categories, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "icm_incident_sub_categories", ["code"], :name => "ICM_INCIDENT_SUB_CATEGORIES_U1"

    create_table "icm_incident_sub_categories_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "incident_sub_category_id", :limit => 22, :collate=>"utf8_bin"
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :icm_incident_sub_categories_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "icm_incident_sub_categories_tl", ["incident_sub_category_id", "language"], :name => "ICM_INCIDENT_SUB_CATEGORIES_TL_U1", :unique => true
    add_index "icm_incident_sub_categories_tl", ["incident_sub_category_id"], :name => "ICM_INCIDENT_SUB_CATEGORIES_TL_N1"

    execute('CREATE OR REPLACE VIEW icm_incident_sub_categories_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM icm_incident_sub_categories t,icm_incident_sub_categories_tl tl
                         WHERE t.id = tl.incident_sub_category_id')
  end
end
