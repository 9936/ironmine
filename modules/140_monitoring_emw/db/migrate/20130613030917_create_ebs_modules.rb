class CreateEbsModules < ActiveRecord::Migration
  def change
    create_table :emw_ebs_modules, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "module_code",  :limit => 30, :null => false
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :emw_ebs_modules, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :emw_ebs_modules_tl, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "ebs_module_id", :limit => 22, :collate => "utf8_bin"
      t.string "language", :limit => 30, :null => false
      t.string "name", :limit => 150
      t.string "description", :limit => 240
      t.string "source_lang", :limit => 30, :null => false
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :emw_ebs_modules_tl, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "emw_ebs_modules_tl", ["ebs_module_id", "language"], :name => "EMW_EBSMODULES_TL_U1", :unique => true
    add_index "emw_ebs_modules_tl", ["ebs_module_id"], :name => "EMW_EBSMOUDLES_TL_N1"

    execute('CREATE OR REPLACE VIEW emw_ebs_modules_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
             FROM emw_ebs_modules t,emw_ebs_modules_tl tl WHERE t.id = tl.ebs_module_id')
  end
end
