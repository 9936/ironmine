class CreateRuleFilterTls < ActiveRecord::Migration
  def change
    create_table :irm_rule_filters_tl do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "rule_filter_id", :limit => 22, :collate => "utf8_bin"
      t.string "language", :limit => 30, :null => false
      t.string "filter_name", :limit => 150
      t.string "filter_description", :limit => 240
      t.string "source_lang", :limit => 30, :null => false
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_rule_filters_tl, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "irm_rule_filters_tl", ["rule_filter_id", "language"], :name => "IRM_RULEFILTERS_TL_U1", :unique => true
    add_index "irm_rule_filters_tl", ["rule_filter_id"], :name => "IRM_RULEFILTERS_TL_N1"

    #将已有的filter的名称保存到多语言表中
    Irm::RuleFilter.all.each do |rf|
      if rf[:filter_name].present?
        filter_name = rf[:filter_name]
      else
        filter_name = '--'
      end
      Irm::RuleFiltersTl.create(:rule_filter_id=> rf.id, :language=>'zh', :source_lang=>'en', :filter_name=> filter_name, :filter_description=> filter_name)
      Irm::RuleFiltersTl.create(:rule_filter_id=> rf.id, :language=>'en', :source_lang=>'en', :filter_name=> filter_name, :filter_description=> filter_name)
    end

    remove_column :irm_rule_filters, :filter_name

    execute('CREATE OR REPLACE VIEW irm_rule_filters_vl AS SELECT t.*,tl.id lang_id,tl.filter_name,tl.filter_description,tl.language,tl.source_lang
             FROM irm_rule_filters t,irm_rule_filters_tl tl WHERE t.id = tl.rule_filter_id')
  end
end
