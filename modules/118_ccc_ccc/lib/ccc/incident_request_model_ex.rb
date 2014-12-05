module Ccc::IncidentRequestModelEx
  def self.included(base)
    base.class_eval do
      has_many :incident_workloads

      scope :with_workloads, lambda{
        select("(SELECT sum(iw.real_processing_time) FROM icm_incident_workloads iw WHERE iw.real_processing_time > 0 AND iw.incident_request_id = #{Icm::IncidentRequest.table_name}.id) total_processing_time")
      }

      scope :with_workloads_remote, lambda{
        select("(SELECT sum(iw.real_processing_time) FROM icm_incident_workloads iw WHERE iw.real_processing_time > 0 AND iw.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND iw.workload_type = 'REMOTE') total_processing_time_remote")
      }

      scope :with_workloads_scene, lambda{
        select("(SELECT sum(iw.real_processing_time) FROM icm_incident_workloads iw WHERE iw.real_processing_time > 0 AND iw.incident_request_id = #{Icm::IncidentRequest.table_name}.id AND iw.workload_type = 'SCENE') total_processing_time_scene")
      }

      validates_presence_of :contact_number

      scope :with_external_system, lambda{|language|
        joins("LEFT OUTER JOIN #{Irm::ExternalSystem.view_name} external_system ON external_system.id = #{table_name}.external_system_id AND external_system.language = '#{language}'").
            select("external_system.system_name external_system_name, external_system.system_description project_info")
      }

      def grouped_workload
        Icm::IncidentWorkload.
            select("SUM(real_processing_time) real_processing_time_g, workload_type").
            select("ip.full_name person_name").
            joins(",irm_people ip").
            where("ip.id = person_id").
            where("incident_request_id = ?", self.id).
            group("person_id, incident_request_id, workload_type")
      end
    end
  end
end