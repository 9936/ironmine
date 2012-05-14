class Chm::ChangeConfigRelation < ActiveRecord::Base
  set_table_name :chm_change_config_relations

  belongs_to :change_request
  belongs_to :config_item,:class_name => "Com::ConfigItem"

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_uniqueness_of :change_request_id,:scope => [:config_item_id]
end
