class CreateCccConnTypes < ActiveRecord::Migration
  def change
    add_column :irm_organizations, :conn_type_id, :string

    create_table "ccc_conn_types", :force => true do |t|
      t.string   "opu_id",       :limit => 22,                        :null => false
      t.string   "code",         :limit => 30,                        :null => false
      t.string   "status_code",  :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",   :limit => 22,                        :null => false
      t.string   "updated_by",   :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ccc_conn_types",  ["code","opu_id"], :name => "ccc_conn_types_U1", :unique => true

    create_table "ccc_conn_types_tl", :force => true do |t|
      t.string   "opu_id",      :limit => 22
      t.string   "conn_type_id", :limit => 22
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

    add_index "ccc_conn_types_tl", ["conn_type_id", "language"], :name => "ccc_conn_types_TL_U1"

    execute('CREATE OR REPLACE VIEW ccc_conn_types_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM ccc_conn_types t,ccc_conn_types_tl tl
                                                 WHERE t.id = tl.conn_type_id')
  end
end
