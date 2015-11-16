class UpdateProjectTable < ActiveRecord::Migration
  def up
    add_column :irm_external_systems, :organization_no, :string # 公司编号
    add_column :irm_external_systems, :customer_no, :string #客户编号
    add_column :irm_external_systems, :project_type_id, :string #项目类型
    add_column :irm_external_systems, :price_type_id, :string #计价方式

    create_table "ccc_project_types", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_project_types",  ["code","opu_id"], :name => "ccc_project_types_U1", :unique => true

    create_table "ccc_project_types_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "project_type_id", :limit => 22
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

    add_index "ccc_project_types_tl", ["project_type_id", "language"], :name => "ccc_project_types_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_project_types_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_project_types t,ccc_project_types_tl tl
                                                 WHERE t.id = tl.project_type_id')


    create_table "ccc_price_types", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_price_types",  ["code","opu_id"], :name => "ccc_price_types_U1", :unique => true

    create_table "ccc_price_types_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "price_type_id", :limit => 22
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

    add_index "ccc_price_types_tl", ["price_type_id", "language"], :name => "ccc_price_types_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_price_types_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_price_types t,ccc_price_types_tl tl
                                                 WHERE t.id = tl.price_type_id')
    
  end

  def down
  end
end
