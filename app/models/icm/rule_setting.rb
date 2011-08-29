class Icm::RuleSetting < ActiveRecord::Base
  set_table_name :icm_rule_settings


  #加入activerecord的通用方法和scope
  query_extend


  def self.list_all
    select("#{table_name}.*").status_meaning
  end

end
