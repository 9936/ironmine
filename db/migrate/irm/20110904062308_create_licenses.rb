class CreateLicenses < ActiveRecord::Migration
  def self.up
    create_table "irm_licenses", :force => true do |t|
      t.string  "code",             :limit => 30
      t.string  "opu_id", :limit => 22
      t.string   "status_code",           :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :irm_licenses, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    create_table "irm_licenses_tl", :force => true do |t|
      t.string    "license_id",:limit => 22,:null => false
      t.string    "name",          :limit=>30,:null=>false
      t.string    "description",   :limit=>150
      t.string    "language",      :limit=>30
      t.string    "source_lang",   :limit=>30
      t.string    "opu_id", :limit => 22
      t.string    "status_code",   :limit => 30, :default=>"ENABLED"
      t.integer   "created_by"
      t.integer   "updated_by"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end

    change_column :irm_licenses_tl, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_licenses_tl", ["license_id", "language"], :name => "IRM_LICENSES_TL_U1", :unique => true

    execute('CREATE OR REPLACE VIEW irm_licenses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_licenses t,irm_licenses_tl tl
                                                 WHERE t.id = tl.license_id')

    create_table :irm_license_functions, :force => true do |t|
      t.string   "license_id",       :limit=>22,:null=>false
      t.string   "function_id",       :limit=>22,:null=>false
      t.string    "opu_id", :limit => 22
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_license_functions, :id, :string,:limit=>22, :null => false ,:collate=>"utf8_bin"

    add_index "irm_license_functions", ["license_id", "function_id"],:unique=>true, :name => "IRM_LICENSE_FUNCTIONS_U1"
  end

  def self.down
    drop_table :irm_licenses
    drop_table :irm_licenses_tl
    execute('Drop VIEW irm_licenses_vl')
    drop_table :irm_license_functions
    end
end
