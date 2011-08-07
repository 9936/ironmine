class CreateSkmColumns < ActiveRecord::Migration
  def self.up
    create_table :skm_columns, :force => true do |t|
      t.string :id, :limit => 22, :null => false
      t.string :company_id, :limit => 22, :null => false
      t.string :parent_column_id, :limit => 22
      t.string :column_code, :limit => 30, :null => false
      t.string   "status_code", :limit => 30, :default=>"ENABLED", :null => false
      t.string  "created_by", :null => false, :limit => 22
      t.string  "updated_by", :null => false, :limit => 22
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
    add_index "skm_columns", ["column_code"], :name => "SKM_COLUMNS_U1", :unique => true

    create_table :skm_columns_tl, :force => true do |t|
      t.string :id, :limit => 22, :null => false
      t.string :company_id, :limit => 22, :null => false
      t.string :column_id, :limit => 22, :null => false
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

    add_index "skm_columns_tl", ["column_id", "language"], :name => "SKM_COLUMNS_TL_U1", :unique => true
    add_index "skm_columns_tl", ["column_id"], :name => "SKM_COLUMNS_TL_N1"

    execute('CREATE OR REPLACE VIEW skm_columns_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                           FROM skm_columns t,skm_columns_tl tl
                                           WHERE t.id = tl.column_id')
  end

  def self.down
    execute('DROP VIEW skm_columns_vl')
    drop_table :skm_columns_tl
    drop_table :skm_columns
  end
end
