class AddBulletinColumnTables < ActiveRecord::Migration
  def self.up
    create_table :irm_bu_columns, :force => true do |t|
      t.string :id, :limit => 22, :null => false
      t.string :company_id, :limit => 22, :null => false
      t.string :parent_column_id, :limit => 22
      t.string :bu_column_code, :limit => 30, :null => false
      t.string   "status_code", :limit => 30, :default=>"ENABLED", :null => false
      t.string  "created_by", :null => false, :limit => 22
      t.string  "updated_by", :null => false, :limit => 22
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
    add_index "irm_bu_columns", ["bu_column_code"], :name => "IRM_BU_COLUMNS_U1", :unique => true

    create_table :irm_bu_columns_tl, :force => true do |t|
      t.string :id, :limit => 22, :null => false
      t.string :company_id, :limit => 22, :null => false
      t.string :bu_column_id, :limit => 22, :null => false
      t.string :name, :limit => 150, :null => false
      t.string :description, :limit => 240
      t.string :language, :limit => 30, :null => false
      t.string :source_lang, :limit => 30, :null => false
      t.string   "status_code", :limit => 30, :default=>"ENABLED", :null => false
      t.string  "created_by", :null => false, :limit => 22
      t.string  "updated_by", :null => false, :limit => 22
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "irm_bu_columns_tl", ["bu_column_id", "language"], :name => "IRM_BU_COLUMNS_TL_U1", :unique => true
    add_index "irm_bu_columns_tl", ["bu_column_id"], :name => "IRM_BU_COLUMNS_TL_N1"

    execute('CREATE OR REPLACE VIEW irm_bu_columns_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM irm_bu_columns t,irm_bu_columns_tl tl
                                           WHERE t.id = tl.bu_column_id')

    create_table :irm_bulletin_columns, :force => true do |t|
      t.string :id, :limit => 22, :null => false
      t.string :company_id, :limit => 22, :null => false
      t.string :bulletin_id, :limit => 22, :null => false
      t.string :bu_column_id, :limit => 22, :null => false
      t.string   "status_code", :limit => 30, :default=>"ENABLED", :null => false
      t.string  "created_by", :null => false, :limit => 22
      t.string  "updated_by", :null => false, :limit => 22
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end

  def self.down
    execute('DROP VIEW irm_bu_columns_vl')
    drop_table :irm_bu_columns
    drop_table :irm_bulletin_columns
  end
end
