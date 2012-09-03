class CreatePortletConfigs < ActiveRecord::Migration
  def change
    create_table "irm_portlet_configs", :force => true do |t|
      t.string   "opu_id",:limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "portal_code",     :limit => 22,                        :null => false
      t.string   "person_id",:limit => 22, :null => false, :collate=>"utf8_bin"
      t.text   "config"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_portlet_configs, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index "irm_portlet_configs", ["person_id"], :name => "IRM_PORTLET_CONFIGS_N1"
  end
end
