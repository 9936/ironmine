class Irm::Jobs::SyncDataAccessJob<Struct.new(:options)
  def perform
    #case options[:type]
    #  # 处理新建,编辑人员(组织与角色字段)
    #  when Irm::Person.name
    #    case options[:operation]
    #      when :create
    #        refresh_person(options[:id])
    #      when :update
    #        refresh_person(options[:id])
    #    end
    #  # 处理编辑组
    #  when Irm::Group.name
    #    case options[:operation]
    #      when :update
    #        refresh_group(options[:id])
    #    end
    #  # 处理添加,删除组成员
    #  when Irm::GroupMember.name
    #    case options[:operation]
    #      when :create
    #        refresh_person(options[:person_id])
    #      when :update
    #        refresh_person(options[:person_id])
    #    end
    #  when Irm::Organization.name
    #    case options[:operation]
    #      when :update
    #        refresh_organization(options[:id])
    #    end
    #  when Irm::Role.name
    #    case options[:operation]
    #      when :update
    #        refresh_role(options[:id])
    #    end
    #
    #  when Irm::BusinessObject.name
    #    case options[:operation]
    #      when :create
    #        refresh_business_object(options[:id])
    #      when :update
    #        refresh_business_object(options[:id])
    #      when :destroy
    #        refresh_business_object(options[:id])
    #    end
    #  when Irm::DataAccess.name
    #    case options[:operation]
    #      when :create
    #        refresh_data_access(options[:organization_id], options[:business_object_id])
    #      when :update
    #        refresh_data_access(options[:organization_id], options[:business_object_id])
    #    end
    #  when Irm::DataShareRule.name
    #    case options[:operation]
    #      when :create
    #        refresh_data_share_rule(options[:rule], options[:origin_rule])
    #      when :update
    #        refresh_data_share_rule(options[:rule], options[:origin_rule])
    #      when :destroy
    #        refresh_data_share_rule(options[:rule], options[:origin_rule])
    #    end
    #end
    Irm::Person.refresh_relation_table
  end

  # 刷新用户数据权限访问控制
  def refresh_person(person_id)
    refresh({:type => Irm::Person.name, :id => person_id})
  end

  # 刷新组成员及下属组成员数据权限访问控制
  def refresh_group(group_id)
    refresh({:type => Irm::Group.name, :id => group_id})
  end

  # 刷新组织成员及下属组织成员数据权限访问控制
  def refresh_organization(org_id)
    refresh({:type => Irm::Organization.name, :id => org_id})
  end

  # 刷新角色成员及下属角色成员数据权限访问控制
  def refresh_role(role_id)
    refresh({:type => Irm::Role.name, :id => role_id})
  end


  # 刷新业务对像数据权限访问控制
  def refresh_business_object(bo_id)

    batch_id = Fwk::IdGenerator.instance.generate("irm_data_accesses_interface")
    Irm::Person.all.each do |person|
      insert_new_person_data([person.id],batch_id,bo_id)
    end

    sql = "DELETE FROM irm_data_accesses_t WHERE business_object_id = '#{bo_id}'"
    ActiveRecord::Base.connection.execute(sql)

    sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) select * from irm_data_accesses_interface WHERE batch_id='#{batch_id}'"
    ActiveRecord::Base.connection.execute(sql)
    sql = "DELETE from irm_data_accesses_interface WHERE batch_id='#{batch_id}'"
    ActiveRecord::Base.connection.execute(sql)
  end


  # 刷新数据访问权限
  def refresh_data_access(org_id, business_object_id)
    if  org_id.present?
      refresh({:type => Irm::DataAccess.name, :org_id => org_id, :business_object_id => business_object_id})
    else
      refresh_business_object(business_object_id)
    end
  end


  def refresh_data_share_rule(rule, origin_rule=nil)
    if origin_rule.present?
      refresh({:type => Irm::DataShareRule.name, :ids => [rule[:source_id], origin_rule[:source_id], rule[:target_id], origin_rule[:target_id]]})
    else
      refresh({:type => Irm::DataShareRule.name, :ids => [rule[:source_id], rule[:target_id]]})
    end
  end

  private
  def prepare_sql(sql, binds)
    sql.gsub("?") { ActiveRecord::Base.sanitize(*binds.shift) }
  end


  def refresh(to)
    batch_id = Fwk::IdGenerator.instance.generate("irm_data_accesses_interface")
    person_ids = ActiveRecord::Base.connection.execute(person_sql(to)).collect{|i| "'#{i[0]}'"}.join(",")
    business_object_id = nil

    if Irm::DataAccess.name.eql?(to[:type])
      business_object_id = to[:business_object_id]
    end

    insert_new_person_data(person_ids,batch_id,business_object_id)

    delete_old_data(to)

    sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) select * from irm_data_accesses_interface WHERE batch_id='#{batch_id}'"
    ActiveRecord::Base.connection.execute(sql)
    sql = "DELETE from irm_data_accesses_interface WHERE batch_id='#{batch_id}'"
    ActiveRecord::Base.connection.execute(sql)
  end

  def person_sql(to={:type => Irm::Person.name, :id => "0"})
    sql = ""
    if Irm::Person.name.eql?(to[:type])
      sql = "SELECT '#{to[:id]}'"
    elsif Irm::DataShareRule.name.eql?(to[:type])
      sql = "SELECT person_id id FROM irm_person_relations_v WHERE source_id in (#{to[:ids]})"
    elsif Irm::DataAccess.name.eql?(to[:type])
      sql = "SELECT person_id id FROM irm_person_relations_v WHERE source_id = '#{to[:org_id]}'"
    else
      sql = "SELECT person_id id FROM irm_person_relations_v WHERE source_id = '#{to[:id]}'"
    end

    sql
  end

  def delete_old_data(to={:type => Irm::Person.name, :id => "0"})
    if Irm::Person.name.eql?(to[:type])
      sql = "DELETE irm_data_accesses_t.* FROM irm_data_accesses_t WHERE source_person_id = '#{to[:id]}' OR target_person_id = '#{to[:id]}'"
    elsif Irm::DataAccess.name.eql?(to[:type])
      sql = "DELETE irm_data_accesses_t.* FROM irm_data_accesses_t INNER JOIN (#{person_sql(to)}) person_data ON (source_person_id = person_data.id OR target_person_id = person_data.id) WHERE business_object_id = '#{to[:business_object_id]}'  "
    else
      sql = "DELETE irm_data_accesses_t.* FROM irm_data_accesses_t INNER JOIN (#{person_sql(to)}) person_data ON source_person_id = person_data.id OR target_person_id = person_data.id "
    end
    ActiveRecord::Base.connection.execute(sql)
  end

  def insert_new_person_data(person_ids,batch_id,business_object_id=nil)
    business_object_filter = ""
    if business_object_id.present?
      business_object_filter = " AND irm_business_objects.id = '#{business_object_id}'"
    end

    irm_data_accesses_person_v = %Q{
     SELECT irm_data_accesses_top_org_v.opu_id,irm_data_accesses_top_org_v.business_object_id,irm_data_accesses_top_org_v.access_type,pva.person_id source_person_id,pvb.person_id target_person_id,irm_data_accesses_top_org_v.access_level
     FROM  irm_data_accesses_top_org_v
     JOIN irm_person_relations_v pva ON irm_data_accesses_top_org_v.source_type = pva.source_type  AND irm_data_accesses_top_org_v.source_id = pva.source_id AND pva.person_id IN (#{person_ids})
     JOIN irm_person_relations_v pvb ON irm_data_accesses_top_org_v.target_type = pvb.source_type  AND irm_data_accesses_top_org_v.target_id = pvb.source_id AND pva.person_id != pvb.person_id
     UNION ALL
     SELECT irm_data_accesses_top_org_v.opu_id,irm_data_accesses_top_org_v.business_object_id,irm_data_accesses_top_org_v.access_type,pva.person_id source_person_id,pvb.person_id target_person_id,irm_data_accesses_top_org_v.access_level
     FROM  irm_data_accesses_top_org_v
     JOIN irm_person_relations_v pva ON irm_data_accesses_top_org_v.source_type = pva.source_type  AND irm_data_accesses_top_org_v.source_id = pva.source_id
     JOIN irm_person_relations_v pvb ON irm_data_accesses_top_org_v.target_type = pvb.source_type  AND irm_data_accesses_top_org_v.target_id = pvb.source_id AND pva.person_id != pvb.person_id  AND pvb.person_id IN (#{person_ids})
     UNION ALL
     SELECT irm_people.opu_id,irm_business_objects.id business_object_id,'SAME_PERSON' access_type,irm_people.id source_person_id,irm_people.id target_person_id,'9' access_level
     FROM irm_people,irm_business_objects
     WHERE irm_people.id IN (#{person_ids})
     AND irm_business_objects.data_access_flag = 'Y' #{business_object_filter}
    }


    irm_data_accesses_v = %Q{
      SELECT '#{batch_id}' batch_id,irm_data_accesses_person_v.opu_id,irm_data_accesses_person_v.business_object_id,irm_business_objects.bo_model_name,irm_data_accesses_person_v.source_person_id,irm_data_accesses_person_v.target_person_id,irm_data_accesses_person_v.access_level access_level,NOW()
    	FROM  (#{irm_data_accesses_person_v}) irm_data_accesses_person_v ,irm_business_objects
      WHERE irm_data_accesses_person_v.business_object_id = irm_business_objects.id #{business_object_filter}
    }

    sql = "INSERT INTO irm_data_accesses_interface(batch_id,opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) #{irm_data_accesses_v}"
    ActiveRecord::Base.connection.execute(sql)
  end

end