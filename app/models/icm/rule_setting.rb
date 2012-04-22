class Icm::RuleSetting < ActiveRecord::Base
  set_table_name :icm_rule_settings


  validates_presence_of :auto_closure_days
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  def self.list_all
    select("#{table_name}.*").status_meaning
  end

end
