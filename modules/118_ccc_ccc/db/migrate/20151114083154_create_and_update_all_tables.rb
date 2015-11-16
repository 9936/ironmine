class CreateAndUpdateAllTables < ActiveRecord::Migration
  def up
    add_column :irm_people, :people_no, :string   #编号
    add_column :irm_people, :sex_id, :string #性别
    add_column :irm_people, :comment, :text #备注
    add_column :irm_people, :delete_flag, :string #删除标记
    
    add_column :irm_people, :customer_status_id, :string #客户状态
    add_column :irm_people, :customer_task, :string #客户职责
    
    add_column :irm_people, :consultant_type_id, :string #顾问类型
    add_column :irm_people, :consultant_module_id, :string #模块
    add_column :irm_people, :consultant_status_id, :string #顾问状态
    add_column :irm_people, :consultant_level_id, :string #顾问等级
    add_column :irm_people, :consultant_no, :string #顾问工号
    add_column :irm_people, :parent_no, :string #上一级顾问工号

    create_table "ccc_consultant_statuses", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_consultant_statuses",  ["code","opu_id"], :name => "ccc_consultant_statuses_U1", :unique => true

    create_table "ccc_consultant_statuses_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "consultant_status_id", :limit => 22
      t.string   "language",        :limit => 30,  :null => false
      t.string   "name",            :limit => 150, :null => false
      t.string   "description",     :limit => 240
      t.string   "source_lang",     :limit => 30,  :null => false
      t.string   "status_code",     :limit => 30,  :null => false
      t.string   "created_by",      :limit => 22
      t.string   "updated_by",      :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_consultant_statuses_tl", ["consultant_status_id", "language"], :name => "ccc_consultant_statuses_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_consultant_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_consultant_statuses t,ccc_consultant_statuses_tl tl
                                                 WHERE t.id = tl.consultant_status_id')
    
    create_table "ccc_customer_statuses", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_customer_statuses",  ["code","opu_id"], :name => "ccc_customer_statuses_U1", :unique => true

    create_table "ccc_customer_statuses_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "customer_status_id", :limit => 22
      t.string   "language",        :limit => 30,  :null => false
      t.string   "name",            :limit => 150, :null => false
      t.string   "description",     :limit => 240
      t.string   "source_lang",     :limit => 30,  :null => false
      t.string   "status_code",     :limit => 30,  :null => false
      t.string   "created_by",      :limit => 22
      t.string   "updated_by",      :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_customer_statuses_tl", ["customer_status_id", "language"], :name => "ccc_customer_statuses_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_customer_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_customer_statuses t,ccc_customer_statuses_tl tl
                                                 WHERE t.id = tl.customer_status_id')
    
    
    create_table "ccc_sexes", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_sexes",  ["code","opu_id"], :name => "ccc_sexes_U1", :unique => true

    create_table "ccc_sexes_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "sex_id", :limit => 22
      t.string   "language",        :limit => 30,  :null => false
      t.string   "name",            :limit => 150, :null => false
      t.string   "description",     :limit => 240
      t.string   "source_lang",     :limit => 30,  :null => false
      t.string   "status_code",     :limit => 30,  :null => false
      t.string   "created_by",      :limit => 22
      t.string   "updated_by",      :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "ccc_sexes_tl", ["sex_id", "language"], :name => "ccc_sexes_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_sexes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_sexes t,ccc_sexes_tl tl
                                                 WHERE t.id = tl.sex_id')
    
    create_table "ccc_consultant_levels", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_consultant_levels",  ["code","opu_id"], :name => "ccc_consultant_levels_U1", :unique => true

    create_table "ccc_consultant_levels_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "consultant_level_id", :limit => 22
      t.string   "language",        :limit => 30,  :null => false
      t.string   "name",            :limit => 150, :null => false
      t.string   "description",     :limit => 240
      t.string   "source_lang",     :limit => 30,  :null => false
      t.string   "status_code",     :limit => 30,  :null => false
      t.string   "created_by",      :limit => 22
      t.string   "updated_by",      :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_consultant_levels_tl", ["consultant_level_id", "language"], :name => "ccc_consultant_levels_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_consultant_levels_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_consultant_levels t,ccc_consultant_levels_tl tl
                                                 WHERE t.id = tl.consultant_level_id')
    
    create_table "ccc_consultant_modules", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_consultant_modules",  ["code","opu_id"], :name => "ccc_consultant_modules_U1", :unique => true

    create_table "ccc_consultant_modules_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "consultant_module_id", :limit => 22
      t.string   "language",        :limit => 30,  :null => false
      t.string   "name",            :limit => 150, :null => false
      t.string   "description",     :limit => 240
      t.string   "source_lang",     :limit => 30,  :null => false
      t.string   "status_code",     :limit => 30,  :null => false
      t.string   "created_by",      :limit => 22
      t.string   "updated_by",      :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_consultant_modules_tl", ["consultant_module_id", "language"], :name => "ccc_consultant_modules_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_consultant_modules_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_consultant_modules t,ccc_consultant_modules_tl tl
                                                 WHERE t.id = tl.consultant_module_id')
    
    create_table "ccc_consultant_types", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_consultant_types",  ["code","opu_id"], :name => "ccc_consultant_types_U1", :unique => true

    create_table "ccc_consultant_types_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "consultant_type_id", :limit => 22
      t.string   "language",        :limit => 30,  :null => false
      t.string   "name",            :limit => 150, :null => false
      t.string   "description",     :limit => 240
      t.string   "source_lang",     :limit => 30,  :null => false
      t.string   "status_code",     :limit => 30,  :null => false
      t.string   "created_by",      :limit => 22
      t.string   "updated_by",      :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_consultant_types_tl", ["consultant_type_id", "language"], :name => "ccc_consultant_types_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_consultant_types_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_consultant_types t,ccc_consultant_types_tl tl
                                                 WHERE t.id = tl.consultant_type_id')
    
  end

  def down
  end
end
