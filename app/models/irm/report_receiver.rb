class Irm::ReportReceiver < ActiveRecord::Base
  set_table_name :irm_report_receivers

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu

  scope :query_person_ids,lambda{
    joins("JOIN #{Irm::Person.relation_view_name} ON  #{Irm::Person.relation_view_name}.source_type = #{table_name}.receiver_type AND #{Irm::Person.relation_view_name}.source_id = #{table_name}.receiver_id").
        select("#{Irm::Person.relation_view_name}.person_id")
  }
end
