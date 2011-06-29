class CreateReportTypeCategories < ActiveRecord::Migration
  def self.up
    create_table "irm_report_type_categories", :force => true do |t|
      t.string :company_id,:limit=>22,:null=>false
      t.string :code,:limit=>30,:null=>false
      t.string  "created_by",:limit=>22,:null=>false
      t.string  "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :irm_report_type_categories_tl, :id, :string,:limit=>22, :null => false

    add_index "irm_report_type_categories", "code",:unique=>true, :name => "IRM_REPORT_TYPE_CATEGORIES_U1"

    create_table "irm_report_type_categories_tl", :force => true do |t|
      t.string  "report_type_category_id",:limit=>22,:null=>false
      t.string   "language",          :limit => 30,  :null => false
      t.string   "name",              :limit => 150, :null => false
      t.string   "description",       :limit => 240
      t.string   "source_lang",       :limit => 30,  :null => false
      t.string   "status_code",       :limit => 30,  :null => false
      t.string  "created_by",:limit=>22,:null=>false
      t.string  "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :irm_report_type_categories_tl, :id, :string,:limit=>22, :null => false

    add_index "irm_report_type_categories_tl", ["report_type_category_id", "language"],:unique=>true, :name => "IRM_REPORT_TYPE_CATEGORIES_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_report_type_categories_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_report_type_categories  t,irm_report_type_categories_tl tl
                                           WHERE t.id = tl.report_type_category_id')
  end

  def self.down
    drop_table :irm_report_type_categories
    drop_table :irm_report_type_categories_tl
    execute('drop view irm_report_type_categories_vl')

  end
end
