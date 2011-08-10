class ReworkPermission < ActiveRecord::Migration
  def self.up
    execute('drop view irm_permissions_vl') if table_exists?(:irm_permissions_vl)
    drop_table :irm_permissions_tl if table_exists?(:irm_permissions_tl)
    drop_table :irm_function_members if table_exists?(:irm_function_members)

    change_column :irm_object_codes,:object_code,:string,:limit=>4,:collate=>"utf8_bin"
    change_column :irm_machine_codes,:machine_code,:string,:limit=>4,:collate=>"utf8_bin"

    create_table :irm_permissions,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :function_id,:limit=>22, :null => false
      t.string   :product_id,:limit=>22, :null => false
      t.string   :code,:limit=>90, :null => false
      t.string   :controller,:limit=>60, :null => false
      t.string   :action,:limit=>30, :null => false
      t.integer  :params_count,:null=>false,:default=>0
      t.string   :direct_get_flag,:limit=>1,:null=>false,:default=>"Y"
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_permissions, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_permissions", "function_id", :name => "IRM_PERMISSIONS_N1"

    add_index "irm_permissions", ["function_id","controller","action"],:unique=>true, :name => "IRM_PERMISSIONS_U1"

    create_table :irm_functions,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :function_group_id,:limit=>22, :null => false
      t.string   :code,:limit=>30, :null => false
      t.string   :login_flag,:limit=>1, :null => false,:default=>"N"
      t.string   :public_flag,:limit=>1, :null => false,:default=>"N"
      t.string   :default_flag,:limit=>1, :null => false,:default=>"N"
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_functions, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_functions", "code",:unique=>true, :name => "IRM_FUNCTIONS_U1"

    create_table :irm_functions_tl, :force => true do |t|
      t.string   "function_id",       :limit=>22,:null=>false
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
    change_column :irm_functions_tl, :id, :string,:limit=>22, :null => false ,:collate=>"utf8_bin"

    add_index "irm_functions_tl", ["function_id", "language"],:unique=>true, :name => "IRM_FUNCTIONS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_functions_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_functions  t,irm_functions_tl tl
                                           WHERE t.id = tl.function_id')


    create_table :irm_function_groups,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :zone_code,:limit=>30, :null => false
      t.string   :code,:limit=>30, :null => false
      t.string   :controller,:limit=>60, :null => false
      t.string   :action,:limit=>30, :null => false
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_function_groups, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_function_groups", "code",:unique=>true, :name => "IRM_FUNCTION_GROUPS_U1"

    create_table :irm_function_groups_tl, :force => true do |t|
      t.string   "function_group_id",       :limit=>22,:null=>false
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
    change_column :irm_function_groups_tl, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_function_groups_tl", ["function_group_id", "language"],:unique=>true, :name => "IRM_FUNCTION_GROUPS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_function_groups_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_function_groups  t,irm_function_groups_tl tl
                                           WHERE t.id = tl.function_group_id')


    create_table :irm_menus,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :code,:limit=>30, :null => false
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_menus, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_menus", "code",:unique=>true, :name => "IRM_MENUS_U1"

    create_table :irm_menus_tl, :force => true do |t|
      t.string   "menu_id",       :limit=>22,:null=>false
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
    change_column :irm_menus_tl, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_menus_tl", ["menu_id", "language"],:unique=>true, :name => "IRM_MENUS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_menus_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_menus  t,irm_menus_tl tl
                                           WHERE t.id = tl.menu_id')

    create_table :irm_menu_entries,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :menu_id,:limit=>22, :null => false
      t.string   :sub_menu_id,:limit=>22
      t.string   :sub_function_group_id,:limit=>22
      t.integer  :display_sequence
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :irm_menu_entries, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_menu_entries", "menu_id", :name => "IRM_MENU_ENTRIES_N1"

    create_table :irm_menu_entries_tl, :force => true do |t|
      t.string   "menu_entry_id",       :limit=>22,:null=>false
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
    change_column :irm_menu_entries_tl, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_index "irm_menu_entries_tl", ["menu_entry_id", "language"],:unique=>true, :name => "IRM_MENU_ENTRIES_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_menu_entries_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_menu_entries  t,irm_menu_entries_tl tl
                                           WHERE t.id = tl.menu_entry_id')
  end

  def self.down
    drop_table :irm_permissions
    drop_table :irm_functions
    drop_table :irm_functions_tl
    execute('drop view irm_functions_vl')
    drop_table :irm_function_groups
    drop_table :irm_function_groups_tl
    execute('drop view irm_function_groups_vl')
    drop_table :irm_menus
    drop_table :irm_menus_tl
    execute('drop view irm_menus_vl')
    drop_table :irm_menu_entries
    drop_table :irm_menu_entries_tl
    execute('drop view irm_menu_entries_vl')
  end
end
