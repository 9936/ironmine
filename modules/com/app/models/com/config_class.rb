class Com::ConfigClass < ActiveRecord::Base
  set_table_name :com_config_classes
  after_save :explore_config_class_hierarchy

  attr_accessor :level
  #多语言关系
  attr_accessor :name,:description
  has_many :config_classes_tls,:dependent => :destroy
  has_many :config_attributes, :dependent => :destroy
  acts_as_multilingual

  validates_presence_of :code

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}

  def explore_config_class_hierarchy
    Com::ConfigClassExplosion.explore_hierarchy(self.id,self.parent_id)
  end

  #查找对应的父级分类的名称
  scope :query_parent,lambda{|language|
    joins("LEFT OUTER JOIN #{view_name} parent ON #{table_name}.parent_id = parent.id AND parent.language = '#{language}'").
        select("parent.name parent_name")
  }

end
