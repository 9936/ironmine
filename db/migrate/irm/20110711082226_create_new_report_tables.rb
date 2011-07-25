class CreateNewReportTables < ActiveRecord::Migration
  def self.up
    create_table :irm_reports,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :report_type_id,:limit=>22, :null => false
      t.string   :report_folder_id,:limit=>22
      t.string   :code,:limit=>30, :null => false
      t.string   :detail_display_flag,:limit=>1, :null =>false,:default=>"Y"
      t.string   :group_field_id,:limit=>22
      t.string   :filter_company_id,:limit=>22, :null => false
      t.string   :filter_date_field_id,:limit=>22
      t.string   :filter_date_range_type,:limit=>30
      t.datetime :filter_date_from
      t.datetime :filter_date_to
      t.string   :limit_field_id,:limit=>22
      t.string   :limit_field_order,:limit=>22
      t.integer  :limit_record_count
      t.string   :raw_condition_clause,:limit=>240
      t.string   :condition_clause,:limit=>240
      t.text     :query_str_cache
      t.string   "status_code", :limit => 30,  :null => false
      t.string   "created_by",:limit=>22,:null=>false
      t.string   "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_reports, :id, :string,:limit=>22, :null => false

    add_index "irm_reports", "code",:unique=>true, :name => "IRM_REPORTS_U1"

    create_table :irm_reports_tl, :force => true do |t|
      t.string   "report_id",     :limit=>22,:null=>false
      t.string   "language",          :limit => 30,  :null => false
      t.string   "name",              :limit => 150, :null => false
      t.string   "description",       :limit => 240
      t.string   "source_lang",       :limit => 30,  :null => false
      t.string   "status_code",       :limit => 30,  :null => false
      t.string   "created_by",:limit=>22,:null=>false
      t.string   "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_reports_tl, :id, :string,:limit=>22, :null => false

    add_index "irm_reports_tl", ["report_id", "language"],:unique=>true, :name => "IRM_REPORTS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_reports_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_reports  t,irm_reports_tl tl
                                           WHERE t.id = tl.report_id')

    create_table "irm_report_criterions", :force => true do |t|
      t.string   "company_id",           :limit => 22,:null => false
      t.string   "report_id",            :limit => 22, :null => false
      t.string   "field_id",             :limit => 22, :null => false
      t.integer  "seq_num",              :null => false
      t.string   "operator_code",        :limit => 30
      t.string   "filter_value",         :limit => 150
      t.string   "status_code",          :limit => 30, :null => false
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_criterions, :id, :string,:limit=>22, :null => false

    add_index "irm_report_criterions", ["report_id"], :name => "IRM_REPORT_CRITERIONS_N1"
    add_index "irm_report_criterions", ["field_id"], :name => "IRM_REPORT_CRITERIONS_N2"

    create_table "irm_report_columns", :force => true do |t|
      t.string   "company_id",         :limit => 22, :null => false
      t.string   "report_id",           :limit => 22, :null => false
      t.string   "field_id",            :limit => 22, :null => false
      t.integer  "seq_num",             :null => false
      t.string   "summary_type",        :limit => 30
      t.string   "status_code",         :limit => 30, :null => false
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_columns, :id, :string,:limit=>22, :null => false
    add_index "irm_report_columns", ["report_id"], :name => "IRM_REPORT_COLUMNS_N1"
    add_index "irm_report_columns", ["field_id"], :name => "IRM_REPORT_COLUMNS_N2"

    create_table "irm_report_group_columns", :force => true do |t|
      t.string   "company_id",         :limit => 22, :null => false
      t.string   "report_id",           :limit => 22, :null => false
      t.string   "field_id",            :limit => 22, :null => false
      t.integer  "seq_num",            :null => false
      t.string   "group_flag",          :limit => 1,:default=>"N"
      t.string   "sort_type",        :limit => 30
      t.string   "group_date_type",     :limit => 150
      t.string   "status_code",         :limit => 30, :null => false
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_group_columns, :id, :string,:limit=>22, :null => false
    add_index "irm_report_group_columns", ["report_id"], :name => "IRM_REPORT_GROUP_COLUMNS_N1"
    add_index "irm_report_group_columns", ["field_id"], :name => "IRM_REPORT_GROUP_COLUMNS_N2"


  end

  def self.down
    drop_table :irm_reports
    drop_table :irm_reports_tl
    execute('drop view irm_reports_vl')
    drop_table :irm_report_criterions
    drop_table :irm_report_columns
    drop_table :irm_report_group_columns
  end
end
