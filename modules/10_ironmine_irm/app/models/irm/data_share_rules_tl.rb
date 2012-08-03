class Irm::DataShareRulesTl < ActiveRecord::Base
  set_table_name :irm_data_share_rules_tl

  belongs_to :data_share_rule
  validates_presence_of :name
end
