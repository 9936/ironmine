class CreateReportFolders < ActiveRecord::Migration
  def self.up
    create_table :irm_report_folders,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :code,:limit=>30, :null => false
      t.string   :access_type,:limit=>22, :null => false
      t.string   :member_type,:limit=>30, :null => false
      t.string   "status_code", :limit => 30,  :null => false
      t.string   "created_by",:limit=>22,:null=>false
      t.string   "updated_by",:limit=>22,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_folders, :id, :string,:limit=>22, :null => false

    add_index "irm_report_folders", "code",:unique=>true, :name => "IRM_REPORT_FOLDERS_U1"

    create_table :irm_report_folders_tl, :force => true do |t|
      t.string   "report_folder_id",     :limit=>22,:null=>false
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
    change_column :irm_report_folders_tl, :id, :string,:limit=>22, :null => false

    add_index "irm_report_folders_tl", ["report_folder_id", "language"],:unique=>true, :name => "IRM_REPORT_FOLDERS_TL_U1"

    execute('CREATE OR REPLACE VIEW irm_report_folders_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_report_folders  t,irm_report_folders_tl tl
                                           WHERE t.id = tl.report_folder_id')


    create_table :irm_report_folder_members do |t|
      t.integer "company_id",       :null => false
      t.integer "report_folder_id",       :null => false
      t.string  "member_type",   :null => false,:limit=>30
      t.string  "member_id",     :null => false ,:limit=>30
      t.string   "status_code",     :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_report_folder_members, :id, :string,:limit=>22, :null => false

  end

  def self.down
    drop_table :irm_report_folders
    drop_table :irm_report_folders_tl
    execute('drop view irm_report_folders_vl')
    drop_table :irm_report_folder_members
  end
end
