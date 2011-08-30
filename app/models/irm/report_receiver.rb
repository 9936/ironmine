class Irm::ReportReceiver < ActiveRecord::Base
  set_table_name :irm_report_receivers


  scope :query_person_ids,lambda{
    joins("JOIN #{Irm::Person.relation_view_name} ON  #{Irm::Person.relation_view_name}.source_type = #{table_name}.receiver_type AND #{Irm::Person.relation_view_name}.source_id = #{table_name}.receiver_id").
        select("#{Irm::Person.relation_view_name}.person_id")
  }
end
