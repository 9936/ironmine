class Com::ConfigRelationType < ActiveRecord::Base
  set_table_name :com_config_relation_types
   #多语言关系
  attr_accessor :name, :description
  has_many   :config_relation_types_tls,:dependent => :destroy
  acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
  validates_presence_of :code
end
