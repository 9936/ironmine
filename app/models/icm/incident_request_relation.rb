class Icm::IncidentRequestRelation < ActiveRecord::Base
  set_table_name :icm_incident_request_relations

  scope :list_all, lambda{|incident_request_id|
    select("ir.id request_id, ir.request_number request_number, ir.title title, #{table_name}.source_id source_id, #{table_name}.target_id target_id, #{table_name}.id relation_id").
        joins(",#{Icm::IncidentRequest.table_name} ir").
        where("(ir.id = #{table_name}.source_id AND ? = #{table_name}.target_id) OR (ir.id = #{table_name}.target_id AND ? = #{table_name}.source_id)", incident_request_id, incident_request_id)
  }
end