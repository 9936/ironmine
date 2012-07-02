class Irm::Rating < ActiveRecord::Base
  set_table_name :irm_ratings

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :group_by_object_grade,lambda{|bo_name,rating_object_id|
    select("grade,count(*) rating_num").where(:bo_name=>bo_name,:rating_object_id=>rating_object_id).group("grade")

  }
end
