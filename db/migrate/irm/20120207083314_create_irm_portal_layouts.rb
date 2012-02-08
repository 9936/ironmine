class CreateIrmPortalLayouts < ActiveRecord::Migration
  def up
    #create table
    create_table "irm_port_layouts", :force => true do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "layout",          :limit => 60, :null => false
      t.string   "default_flag",  :limit => 1, :null => false,:default=>"N"
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_port_layouts, "id", :string,:limit=>22, :collate=>"utf8_bin"


    create_table "irm_port_layouts_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "portal_layout_id",         :limit => 30, :collate=>"utf8_bin", :null => false
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

    change_column :irm_port_layouts_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index "irm_port_layouts_tl", ["layout_id", "language"], :name => "IRM_PORT_LAYOUTS_TL_U1", :unique => true
    add_index "irm_port_layouts_tl", ["layout_id"],             :name => "IRM_PORT_LAYOUTS_TL_N1"
    execute('CREATE OR REPLACE VIEW irm_port_layouts_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM irm_port_layouts t,irm_port_layouts_tl tl
                         WHERE t.id = tl.layout_id')
  end

  def down
    drop_table :irm_port_layouts
    drop_table :irm_port_layouts_tl
    execute('DROP VIEW irm_port_layouts_vl')
  end
end
