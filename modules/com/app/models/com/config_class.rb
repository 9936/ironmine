class Com::ConfigClass < ActiveRecord::Base
  set_table_name :com_config_classes
  after_save :explore_config_class_hierarchy

  attr_accessor :level
  #多语言关系
  attr_accessor :name,:description
  has_many :config_classes_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :code

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}

  def explore_config_class_hierarchy
    Com::ConfigClassExplosion.explore_hierarchy(self.id,self.parent_id)
  end

end
