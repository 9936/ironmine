class Irm::DataAccess < ActiveRecord::Base
  set_table_name :irm_data_accesses


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_business_object,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::BusinessObject.view_name} ON #{table_name}.business_object_id = #{Irm::BusinessObject.view_name}.id AND #{Irm::BusinessObject.view_name}.language = '#{language}'").
        select("#{Irm::BusinessObject.view_name}.name business_object_name")
  }

  scope :opu_data_access,lambda{where(:organization_id=>nil)}

  scope :org_data_access,lambda{|org_id|
    where(:organization_id=>org_id)
  }

  # 数据访问级别
  scope :with_access_level,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} access_level ON access_level.lookup_type='IRM_DATA_ACCESS_LEVEL' AND access_level.lookup_code = #{table_name}.access_level AND access_level.language= '#{language}'").
    select(" access_level.meaning access_level_name")
  }

  def self.prepare_for_opu
    access_objects = Irm::BusinessObject.joins("LEFT JOIN #{table_name} ON #{table_name}.business_object_id = #{Irm::BusinessObject.table_name}.id").
        where(:data_access_flag=>Irm::Constant::SYS_YES).
        select("#{Irm::BusinessObject.table_name}.id business_object_id,#{table_name}.id access_id")

    access_objects.select{|i| i.access_id.nil? }.each do |ao|
      self.create(:business_object_id=>ao[:business_object_id],:access_level=>2)
    end
  end

  def self.list_all
    self.select_all.with_business_object(I18n.locale).with_access_level(I18n.locale)
  end

  def self.bo_id_data_access(business_object_id,source_person_id,access_level=2,target_person_id="'#{Irm::Person.current.id}'")

    org = %Q(
      SELECT 1
      FROM  irm_business_objects,irm_people pa,irm_people pb,irm_same_org_access_level
      WHERE irm_business_objects.id = '#{business_object_id}'
        AND irm_business_objects.data_access_flag = "Y"
        AND (pa.organization_id = pb.organization_id
             OR(EXISTS(SELECT 1 FROM irm_organization_explosions,irm_data_accesses
                       WHERE irm_data_accesses.organization_id IS NULL
                         AND irm_data_accesses.hierarchy_access_flag='Y'
                         AND irm_data_accesses.business_object_id = '#{business_object_id}'
                         AND irm_organization_explosions.organization_id = pa.organization_id
                         AND irm_organization_explosions.parent_org_id = pb.organization_id )
             )
            )
        AND pa.id = #{source_person_id}
        AND pb.id = #{target_person_id}
        AND irm_same_org_access_level.business_object_id =  irm_business_objects.id
        AND irm_same_org_access_level.id =  pa.organization_id
        AND irm_same_org_access_level.access_level >= #{access_level}

    )

    share_rule = %Q(
      SELECT 1 FROM irm_data_share_rules,irm_person_relations_v pva,irm_person_relations_v pvb
      WHERE irm_data_share_rules.business_object_id = '#{business_object_id}'
        AND irm_data_share_rules.source_type = pva.source_type
        AND irm_data_share_rules.source_id = pva.source_id
        AND irm_data_share_rules.target_type = pvb.source_type
        AND irm_data_share_rules.target_id = pvb.source_id
        AND pva.person_id = #{source_person_id}
        AND pvb.person_id = #{target_person_id}
        AND pva.person_id != pvb.person_id
        AND irm_data_share_rules.access_level >= #{access_level}
    )

    extend_query = %Q(
      #{source_person_id} = #{target_person_id}
      OR EXISTS(#{org})
      OR EXISTS(#{share_rule})
    )

    irm_data_accesses_person_v = %Q{
     #{source_person_id} = #{target_person_id}
     OR
     EXISTS(
       SELECT 1
       FROM  irm_data_accesses_top_org_v
       JOIN irm_person_relations_v pva ON irm_data_accesses_top_org_v.source_type = pva.source_type  AND irm_data_accesses_top_org_v.source_id = pva.source_id
       JOIN irm_person_relations_v pvb ON irm_data_accesses_top_org_v.target_type = pvb.source_type  AND irm_data_accesses_top_org_v.target_id = pvb.source_id  AND pva.person_id != pvb.person_id
       WHERE irm_data_accesses_top_org_v.access_level >= #{access_level}
         AND irm_data_accesses_top_org_v.business_object_id
         AND pva.person_id = #{source_person_id}
         AND pvb.person_id = #{target_person_id}
     )
    }

    extend_query
  end


  def self.data_access(business_object_name,source_person_id,access_level=2,target_person_id="'#{Irm::Person.current.id}'")
    business_object_id = Irm::BusinessObject.where(:bo_model_name => business_object_name).first.id
    self.bo_id_data_access(business_object_id,source_person_id,access_level=2,target_person_id="'#{Irm::Person.current.id}'")
  end
end
