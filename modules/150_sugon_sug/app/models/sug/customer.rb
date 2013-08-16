class Sug::Customer < ActiveRecord::Base
  set_table_name :sug_customers

  after_save :explore_hierarchy

  attr_accessor :level

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_parent,lambda{
    joins("LEFT OUTER JOIN #{table_name} parent ON #{table_name}.parent_id = parent.id").
        select("parent.name parent_name")
  }

  def explore_hierarchy
    Sug::CustomerExplosion.explore_hierarchy(self.id, self.parent_id)
  end

end
