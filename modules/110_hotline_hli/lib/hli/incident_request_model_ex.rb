module Hli::IncidentRequestModelEx
  def self.included(base)
    base.class_eval do
      has_many :incident_workloads

      scope :with_workloads, lambda{
        select("(SELECT sum(iw.real_processing_time) FROM icm_incident_workloads iw WHERE iw.real_processing_time > 0 AND iw.incident_request_id = #{Icm::IncidentRequest.table_name}.id) total_processing_time")
      }

    #  def self.search(query)
    ##    self.list_all.where("#{table_name}.title like ?","%#{query}%")
    #    results = Sunspot.search(Icm::IncidentRequest) do |s|
    #        s.fulltext query
    #        #s.with(:external_system_content, '000q00073mabtnlQVNXL5U')
    #        s.paginate :per_page => 30000
    #    end.results
    #    Icm::IncidentRequest.where("#{Icm::IncidentRequest.table_name}.id IN (?)", results.collect(&:id)).
    #        relate_person(Irm::Person.current.id).
    #        select_all.
    #        with_incident_status(I18n.locale).
    #        with_requested_by(I18n.locale).
    #        with_supporter(I18n.locale).
    #        with_organization(I18n.locale).
    #        order("(request_number + 0) DESC")
    #  end

      def self.search(query)
        search = Sunspot.search(Icm::IncidentRequest) do |sq|
          sq.keywords query
          s.paginate :per_page => 30000
        end
        #对result进行判断是否来自于附件，如果来自于附件需要对其进行特殊处理
        #incident_request_ids = []
        #if search.results.any?
        #  search.results.each do |result|
        #    #if result.class.to_s.eql?('Irm::AttachmentVersion')
        #    #  #如果搜索附件来自于回复
        #    #  if result.source_type.to_s.eql?('Icm::IncidentJournal')
        #    #    result = Icm::IncidentJournal.find(result.source_id)
        #    #    incident_request_ids << result.incident_request_id unless incident_request_ids.include?(result.incident_request_id)
        #    #  else
        #    #    incident_request_ids << result.source_id unless incident_request_ids.include?(result.source_id)
        #    #  end
        #    #else
        #      incident_request_ids << result.id unless incident_request_ids.include?(result.id)
        #    #end
        #  end
        #end
        Icm::IncidentRequest.where("#{Icm::IncidentRequest.table_name}.id IN (?)", search.results.collect(&:id)).
            relate_person(Irm::Person.current.id).
            select_all.
            with_incident_status(I18n.locale).
            with_requested_by(I18n.locale).
            with_supporter(I18n.locale).
            with_organization(I18n.locale).
            order("(request_number + 0) DESC")
        #Icm::IncidentRequest.where("#{Icm::IncidentRequest.table_name}.id IN (?)", incident_request_ids).list_all
      end

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