class Sug::PersonSkill < ActiveRecord::Base
  set_table_name :sug_person_skills


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_by_person, lambda {|person_id|
        where("#{table_name}.person_id=?", person_id)
  }


end