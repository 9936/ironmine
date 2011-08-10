class CreateProfileModuleTables < ActiveRecord::Migration
  def self.up
    create_table :irm_tabs,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :business_object_id,:limit=>22
      t.string   :code,:limit=>30, :null => false
      t.string   :function_group_id,:limit=>22, :null => false
      t.string   :style_color,:limit=>30
      t.string   :style_image,:limit=>30
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_tabs, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    create_table :irm_tabs_tl, :force => true do |t|
      t.string   "tab_id",       :limit=>22,:null=>false
      t.string   "language",          :limit => 30,  :null => false
      t.string   "name",              :limit => 150, :null => false
      t.string   "description",       :limit => 240
      t.string   "source_lang",       :limit => 30,  :null => false
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_tabs_tl, :id, :string,:limit=>22, :null => false ,:collate=>"utf8_bin"

    add_index "irm_tabs_tl", ["tab_id", "language"],:unique=>true, :name => "IRM_TABS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_tabs_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_tabs t,irm_tabs_tl tl
                                           WHERE t.id = tl.tab_id')


    create_table :irm_applications,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :code,:limit=>30, :null => false
      t.string   :image_id,:limit=>22
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_applications, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"


    create_table :irm_applications_tl, :force => true do |t|
      t.string   "application_id",       :limit=>22,:null=>false
      t.string   "language",          :limit => 30,  :null => false
      t.string   "name",              :limit => 150, :null => false
      t.string   "description",       :limit => 240
      t.string   "source_lang",       :limit => 30,  :null => false
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_applications_tl, :id, :string,:limit=>22, :null => false ,:collate=>"utf8_bin"

    add_index "irm_applications_tl", ["application_id", "language"],:unique=>true, :name => "IRM_APPLICATIONS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_applications_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_applications t,irm_applications_tl tl
                                           WHERE t.id = tl.application_id')

    create_table :irm_application_tabs, :force => true do |t|
      t.string   "application_id",       :limit=>22,:null=>false
      t.string   "tab_id",       :limit=>22,:null=>false
      t.string   :default_flag,  :limit=>1,:null=>false,:default=>"N"
      t.integer  :seq_num,:null=>false
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_application_tabs, :id, :string,:limit=>22, :null => false ,:collate=>"utf8_bin"

    add_index "irm_application_tabs", ["application_id", "tab_id"],:unique=>true, :name => "IRM_APPLICATION_TABS_U1"


    create_table :irm_profiles,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :user_license,:limit=>30, :null => false
      t.string   :code,:limit=>30, :null => false
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_profiles, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_profiles", "code",:unique=>true, :name => "IRM_PROFILES_U1"

    create_table :irm_profiles_tl, :force => true do |t|
      t.string   "profile_id",       :limit=>22,:null=>false
      t.string   "language",          :limit => 30,  :null => false
      t.string   "name",              :limit => 150, :null => false
      t.string   "description",       :limit => 240
      t.string   "source_lang",       :limit => 30,  :null => false
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_profiles_tl, :id, :string,:limit=>22, :null => false ,:collate=>"utf8_bin"

    add_index "irm_profiles_tl", ["profile_id", "language"],:unique=>true, :name => "IRM_PROFILES_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_profiles_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_profiles t,irm_profiles_tl tl
                                           WHERE t.id = tl.profile_id')


    create_table :irm_profile_applications, :force => true do |t|
      t.string   "profile_id",       :limit=>22,:null=>false
      t.string   "application_id",       :limit=>22,:null=>false
      t.string   :default_flag,  :limit=>1,:null=>false,:default=>"N"
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_profile_applications, :id, :string,:limit=>22, :null => false ,:collate=>"utf8_bin"

    add_index "irm_profile_applications", ["profile_id", "application_id"],:unique=>true, :name => "IRM_PROFILE_APPLICATIONS_U1"

    create_table :irm_profile_functions, :force => true do |t|
      t.string   "profile_id",       :limit=>22,:null=>false
      t.string   "function_id",       :limit=>22,:null=>false
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_profile_functions, :id, :string,:limit=>22, :null => false ,:collate=>"utf8_bin"

    add_index "irm_profile_functions", ["profile_id", "function_id"],:unique=>true, :name => "IRM_PROFILE_FUNCTIONS_U1"
  end

  def self.down
    drop_table :irm_tabs
    drop_table :irm_tabs_tl
    execute('drop view irm_tabs_vl')
    drop_table :irm_applications
    drop_table :irm_applications_tl
    execute('drop view irm_applications_vl')
    drop_table :irm_application_tabs
    drop_table :irm_profiles
    drop_table :irm_profiles_tl
    execute('drop view irm_profiles_vl')
    drop_table :irm_profile_applications
    drop_table :irm_profile_functions
  end
end
