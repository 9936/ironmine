module Hli::IncidentRequestModelEx
  def self.included(base)
    base.class_eval do
      has_many :incident_workloads

      scope :with_workloads, lambda{
        select("(SELECT sum(iw.real_processing_time) FROM icm_incident_workloads iw WHERE iw.real_processing_time > 0 AND iw.incident_request_id = #{Icm::IncidentRequest.table_name}.id) total_processing_time")
      }
    end
  end
end