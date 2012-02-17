class Irm::DataShareRule < ActiveRecord::Base
  set_table_name :irm_data_share_rules
   #多语言关系
  attr_accessor :name, :description
  has_many   :data_share_rules_tls,:dependent => :destroy
  acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
  validates_presence_of :code ,:business_object_id,:rule_type,:source_type,:source_id,:target_type,:target_id,:access_level

end
