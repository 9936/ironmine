class CreateIrmDataShareRules < ActiveRecord::Migration
  def change
    create_table :irm_data_share_rules do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "code",          :limit => 30, :null => false
      t.string   "business_object_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "rule_type",          :limit => 30, :null => false
      t.string   "source_type",          :limit => 30, :null => false
      t.string   "source_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "target_type",          :limit => 30, :null => false
      t.string   "target_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "access_level",          :limit => 30, :null => false
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_data_share_rules, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index "irm_data_share_rules_tl", ["business_object_id"], :name => "IRM_DATA_SHARE_RULES_N1"
    add_index "irm_data_share_rules_tl", ["source_id"], :name => "IRM_DATA_SHARE_RULES_N2"
    add_index "irm_data_share_rules_tl", ["target_id"], :name => "IRM_DATA_SHARE_RULES_N3"




    create_table "irm_data_share_rules_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "data_share_rule_id",         :limit => 30, :collate=>"utf8_bin", :null => false
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

    change_column :irm_data_share_rules_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index "irm_data_share_rules_tl", ["data_share_rule_id", "language"], :name => "IRM_DATA_SHARE_RULES_U1", :unique => true
    add_index "irm_data_share_rules_tl", ["data_share_rule_id"],             :name => "IRM_DATA_SHARE_RULES_N1"
    execute('CREATE OR REPLACE VIEW irm_data_share_rules_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM irm_data_share_rules t,irm_data_share_rules_tl tl
                         WHERE t.id = tl.data_share_rule_id')
  end
end
