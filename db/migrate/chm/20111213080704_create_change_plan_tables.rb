class CreateChangePlanTables < ActiveRecord::Migration
  def up
    create_table "chm_change_plan_types", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.integer  "display_sequence" ,:default=>10
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_plan_types, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_plan_types", ["code"], :name => "CHM_CHANGE_PLAN_TYPES_N1"

    create_table "chm_change_plan_types_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "change_plan_type_id",:limit => 22, :collate=>"utf8_bin"
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",      :limit => 30, :null => false
      t.string   "created_by",       :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :chm_change_plan_types_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_plan_types_tl", ["change_plan_type_id", "language"], :name => "CHM_CHANGE_PLAN_TYPES_TL_U1", :unique => true
    add_index "chm_change_plan_types_tl", ["change_plan_type_id"], :name => "CHM_CHANGE_PLAN_TYPES_TL_N1"

    execute('CREATE OR REPLACE VIEW chm_change_plan_types_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM chm_change_plan_types t,chm_change_plan_types_tl tl
                         WHERE t.id = tl.change_plan_type_id')


    create_table "chm_change_plans", :force => true do |t|
      t.string   "opu_id",             :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "change_request_id",  :limit => 22, :collate=>"utf8_bin"
      t.string   "change_plan_type_id",:limit => 22, :collate=>"utf8_bin"
      t.string   "planed_by",          :limit => 22, :null => false
      t.text     "plan_body"
      t.string   "status_code",        :limit => 30, :null => false
      t.string   "created_by",         :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",         :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_plans, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_plans", ["change_request_id", "change_plan_type_id"], :name => "CHM_CHANGE_PLANS_TL_U1", :unique => true

  end

  def down
  end
end
