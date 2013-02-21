class Slm::Calendar < ActiveRecord::Base
  set_table_name :slm_calendars

  #多语言关系
  attr_accessor :name,:description
  has_many :calendars_tls, :dependent => :destroy
  acts_as_multilingual

  validates_presence_of :external_system_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_system, lambda {|external_system_id|
    where("external_system_id=?", external_system_id)
  }

end
