class AddDataRangeToRuleFilters < ActiveRecord::Migration
  def change
    add_column :irm_rule_filters,:data_range,:string,:limit=>1,:default=>"Y",:after=>:source_code
  end
end
