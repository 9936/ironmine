class Irm::RatingConfigGrade < ActiveRecord::Base
  set_table_name :irm_rating_config_grades
  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}
  validates_presence_of :grade

  attr_accessor :rating_num

  belongs_to :rating_config

  scope :by_config_code,lambda{|code|
    joins("JOIN #{Irm::RatingConfig.table_name} ON #{Irm::RatingConfig.table_name}.id = #{table_name}.rating_config_id").
        where("#{Irm::RatingConfig.table_name}.code = ?",code)
  }

end