class Skm::EntryStatus < ActiveRecord::Base
  set_table_name :skm_entry_statuses

  #知识库状态相关的常量
  PUBLISHED = "PUBLISHED"
  WAIT_APPROVE = "WAIT_APPROVE"
  APPROVE_DENY = "APPROVE_DENY"
  SYS_REFUSE = 'R'
  SYS_CHANGE = 'C'

  #多语言关系
  attr_accessor :name,:description
  has_many :entry_statuses_tls, :dependent => :destroy
  acts_as_multilingual

  validates_presence_of :entry_status_code
  validates_uniqueness_of :entry_status_code,:scope=>[:opu_id]

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end