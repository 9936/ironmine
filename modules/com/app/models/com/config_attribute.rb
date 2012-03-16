class Com::ConfigAttribute < ActiveRecord::Base
  set_table_name :com_config_attributes

  #多语言关系
  attr_accessor :name,:description
  has_many :config_attributes_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :code

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}


  scope :query_attributes_by_class_id, lambda { |class_id|
    self.multilingual.where(:id => self.find_by_sql("select id from com_config_classes_attributes_vl where config_class_id='#{class_id}'"))
  }

end
