class Sug::CategorySkill < ActiveRecord::Base
  set_table_name :sug_category_skills


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_presence_of :category_id, :skill_id
  validates_uniqueness_of :category_id, :scope => :skill_id


end