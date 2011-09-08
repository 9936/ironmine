class Irm::ReportTypeObject < ActiveRecord::Base
  set_table_name :irm_report_type_objects

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  belongs_to :report_type

  belongs_to :business_object

  scope :with_bo,lambda{|language|
    joins("JOIN #{Irm::BusinessObject.view_name} ON #{Irm::BusinessObject.view_name}.id = #{table_name}.business_object_id AND #{Irm::BusinessObject.view_name}.language = '#{language}'").
    select("#{Irm::BusinessObject.view_name}.name relation_business_object_name")
  }

  scope :select_all,lambda{
    select("#{table_name}.*")
  }
end
