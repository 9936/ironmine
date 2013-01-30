class Irm::RuleFiltersTl < ActiveRecord::Base
  set_table_name :irm_rule_filters_tl
  belongs_to :rule_filter

  validates_presence_of :filter_name
end
