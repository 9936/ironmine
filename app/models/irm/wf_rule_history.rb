class Irm::WfRuleHistory < ActiveRecord::Base
  set_table_name :irm_wf_rule_histories

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu
end
