module Hli::IncidentRequestModelEx
  def self.included(base)
    base.class_eval do
      has_many :incident_workloads

      scope :with_workloads, lambda{
        select("(SELECT sum(iw.real_processing_time) FROM icm_incident_workloads iw WHERE iw.real_processing_time > 0 AND iw.incident_request_id = #{Icm::IncidentRequest.table_name}.id) total_processing_time")
      }

      #scope :relate_person,lambda{|person_id|
      #  where(%Q(EXISTS(SELECT 1 FROM
      #            #{Irm::Watcher.table_name} watcher
      #            WHERE watcher.watchable_id = #{table_name}.id
      #            AND watcher.watchable_type = ?
      #            AND watcher.member_id = ? AND watcher.member_type = ? )
      #            OR (EXISTS(SELECT 1 FROM (
      #                    select
      #                        tmp.opu_id AS opu_id,
      #                        tmp.business_object_id AS business_object_id,
      #                        irm_business_objects.bo_model_name AS bo_model_name,
      #                        tmp.source_person_id AS source_person_id,
      #                        tmp.target_person_id AS target_person_id,
      #                        max(tmp.access_level) AS access_level
      #                    from
      #                        (
      #                    select
      #                        irm_data_accesses_top_org_v.opu_id AS opu_id,
      #                        irm_data_accesses_top_org_v.business_object_id AS business_object_id,
      #                        irm_data_accesses_top_org_v.access_type AS access_type,
      #                        pva.person_id AS source_person_id,
      #                        pvb.person_id AS target_person_id,
      #                        irm_data_accesses_top_org_v.access_level AS access_level
      #                    from
      #                        irm_data_accesses_top_org_v
      #                        ,irm_person_relations_v pva
      #                        ,irm_person_relations_v pvb
      #                    where
      #                        ((irm_data_accesses_top_org_v.source_type = pva.source_type) and
      #                        (irm_data_accesses_top_org_v.source_id = pva.source_id) and (irm_data_accesses_top_org_v.target_type = pvb.source_type)
      #                        and (irm_data_accesses_top_org_v.target_id = pvb.source_id) and (pva.person_id <> pvb.person_id) and (pvb.person_id = ?) )
      #                    union all select
      #                        irm_people.opu_id AS opu_id,
      #                        irm_business_objects.id AS business_object_id,
      #                        'SAME_PERSON' AS access_type,
      #                        irm_people.id AS source_person_id,
      #                        irm_people.id AS target_person_id,
      #                        '9' AS access_level
      #                    from
      #                        (irm_people
      #                        join irm_business_objects)
      #                    where
      #                        (irm_business_objects.data_access_flag = 'Y') AND irm_people.id = ?
      #                    ) tmp
      #                        join irm_business_objects
      #                    where
      #                        (tmp.business_object_id = irm_business_objects.id)
      #                    group by tmp.opu_id , tmp.business_object_id , irm_business_objects.bo_model_name , tmp.source_person_id , tmp.target_person_id
      #
      #            ) ida
      #            WHERE ida.source_person_id = #{table_name}.requested_by
      #            AND ida.bo_model_name = ? AND ida.access_level > ?))),
      #  Icm::IncidentRequest.name,
      #  person_id,
      #  Irm::Person.name,
      #  person_id,
      #  person_id,
      #  Icm::IncidentRequest.name,
      #  "0")
      #}
    end
  end
end