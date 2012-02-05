class CreatePortlets < ActiveRecord::Migration
  def up
    create_table "irm_portlets", :force => true do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.string   "controller",    :limit => 50, :null => false
      t.string   "action",        :limit => 40, :null => false
      t.string   "default_flag",  :limit => 1, :null => false,:default=>"N"
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_portlets, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index "irm_portlets", ["code"], :name => "IRM_PORTLETS_N1"

    create_table "irm_portlets_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "portlet_id",      :limit => 22, :collate=>"utf8_bin"
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

    change_column :irm_portlets_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "irm_portlets_tl", ["portlet_id", "language"], :name => "IRM_PORTLETS_TL_U1", :unique => true
    add_index "irm_portlets_tl", ["portlet_id"],             :name => "IRM_PORTLETS_TL_N1"

    execute('CREATE OR REPLACE VIEW irm_portlets_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM irm_portlets t,irm_portlets_tl tl
                         WHERE t.id = tl.portlet_id')
  end

  def down
    drop_table :irm_portlets
    drop_table :irm_portlets_tl
    execute('DROP VIEW irm_portlets_vl')
  end
end
