class ReworkOrganization < ActiveRecord::Migration
  def self.up
    add_column :irm_organizations,:parent_org_id,:string,:limit=>22,:after=>:opu_id

    execute('CREATE OR REPLACE VIEW irm_organizations_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_organizations t,irm_organizations_tl tl
                                                 WHERE t.id = tl.organization_id')

    create_table "irm_organization_explosions", :force => true do |t|
      t.string "parent_org_id",        :limit => 22,:null => false
      t.string "direct_parent_org_id", :limit => 22,:null => false
      t.string "organization_id",      :limit => 22,:null => false
      t.string "opu_id",               :limit => 22,:null => false
      t.string   "status_code",        :limit => 30, :default=>"ENABLED"
      t.string  "created_by",          :limit => 22,:null => false
      t.string  "updated_by",          :limit => 22,:null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :irm_organization_explosions, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_organization_explosions", ["parent_org_id","direct_parent_org_id","organization_id"],:name => "IRM_ORGANIZATION_EXPLOSIONS_U1", :unique => true

    drop_table :irm_companies
    drop_table :irm_companies_tl
    execute("drop view irm_companies_vl")
    drop_table :irm_company_accesses
    drop_table :irm_departments
    drop_table :irm_departments_tl
    execute("drop view irm_departments_vl")

  end

  def self.down
    remove_column :irm_organizations,:parent_org_id

    drop_table :irm_organization_explosions

    create_table "irm_companies", :force => true do |t|
      t.string "short_name",        :limit => 30,:null => false
      t.string "company_type",      :limit => 30,:null => false
      t.string "time_zone",         :limit => 30
      t.string "currency_code",     :limit => 30
      t.string "cost_center_code",  :limit => 30
      t.string "budget_code",       :limit => 30
      t.string "hotline",           :limit => 30
      t.string "home_page",         :limit => 60
      t.string   "type",               :limit => 60
      t.string   "status_code",     :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "irm_companies", ["short_name"],:name => "IRM_COMPANIES_U1", :unique => true

    create_table "irm_companies_tl", :force => true do |t|
      t.integer   "company_id",    :null=>false
      t.string    "name",          :limit=>30,:null=>false
      t.string    "description",   :limit=>150
      t.string    "language",      :limit=>30
      t.string    "source_lang",   :limit=>30
      t.string    "status_code",   :limit => 30, :default=>"ENABLED"
      t.integer   "created_by"
      t.integer   "updated_by"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end

    add_index "irm_companies_tl", ["company_id", "language"], :name => "IRM_COMPANIES_TL_U1", :unique => true

    create_table "irm_company_accesses", :force => true do |t|
      t.integer "person_id",              :null => false
      t.integer "accessable_company_id",  :null => false
      t.string   "status_code",           :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "irm_company_accesses", ["person_id","accessable_company_id"],:name => "IRM_COMPANY_ACCESSES_U1", :unique => true



    execute('CREATE OR REPLACE VIEW irm_companies_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_companies  t,irm_companies_tl tl
                                             WHERE t.id = tl.company_id')



    execute('CREATE OR REPLACE VIEW irm_organizations_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_organizations t,irm_organizations_tl tl
                                                 WHERE t.id = tl.organization_id')

    create_table "irm_departments", :force => true do |t|
      t.integer "company_id",       :null => false
      t.integer "organization_id",  :null => false
      t.string  "short_name",       :limit => 30,:null => false
      t.string   "status_code",     :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "irm_departments", ["organization_id","short_name"], :name => "IRM_DEPARTMENTS_U1",:unique=>true

    create_table "irm_departments_tl", :force => true do |t|
      t.integer   "company_id",       :null => false
      t.integer   "department_id",    :null=>false
      t.string    "name",          :limit=>30,:null=>false
      t.string    "description",   :limit=>150
      t.string    "language",      :limit=>30
      t.string    "source_lang",   :limit=>30
      t.string    "status_code",   :limit => 30, :default=>"ENABLED"
      t.integer   "created_by"
      t.integer   "updated_by"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end

    add_index "irm_departments_tl", ["department_id", "language"], :name => "IRM_DEPARTMENTS_TL_U1", :unique => true

    execute('CREATE OR REPLACE VIEW irm_departments_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_departments t,irm_departments_tl tl
                                                 WHERE t.id = tl.department_id')

  end
end
