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
    #        refresh_data_access(options[:organization_id],options[:business_object_id])
    #      when :update
    #        refresh_data_access(options[:organization_id],options[:business_object_id])
    #    end
    #  when Irm::DataShareRule.name
    #    case options[:operation]
    #      when :create
    #        refresh_data_share_rule(options[:rule],options[:origin_rule])
    #      when :update
    #        refresh_data_share_rule(options[:rule],options[:origin_rule])
    #      when :destroy
    #        refresh_data_share_rule(options[:rule],options[:origin_rule])
    #    end
    #end
    Irm::Person.refresh_relation_table
  end

  # 刷新用户数据权限访问控制
  def refresh_person(person_id)
    sql = "DELETE FROM irm_data_accesses_t WHERE source_person_id = ? OR target_person_id = ?"
    sql = prepare_sql(sql,[person_id, person_id])
    ActiveRecord::Base.connection.execute(sql)

    sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v WHERE source_person_id = ? OR target_person_id = ?"
    sql = prepare_sql(sql,[person_id, person_id])
    ActiveRecord::Base.connection.execute(sql)


  end

  # 刷新组成员及下属组成员数据权限访问控制
  def refresh_group(group_id)
    sql = "DELETE FROM irm_data_accesses_t WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?)"
    sql = prepare_sql(sql,[group_id, group_id])
    ActiveRecord::Base.connection.execute(sql)

    sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?)"
    sql = prepare_sql(sql,[group_id, group_id])
    ActiveRecord::Base.connection.execute(sql)

  end

  # 刷新组织成员及下属组织成员数据权限访问控制
  def refresh_organization(org_id)
    sql = "DELETE FROM irm_data_accesses_t WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?)"
    sql = prepare_sql(sql,[org_id, org_id])
    ActiveRecord::Base.connection.execute(sql)

    sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?)"
    sql = prepare_sql(sql,[org_id, org_id])
    ActiveRecord::Base.connection.execute(sql)
  end

  # 刷新角色成员及下属角色成员数据权限访问控制
  def refresh_role(role_id)
    sql = "DELETE FROM irm_data_accesses_t WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?)"
    sql = prepare_sql(sql,[role_id, role_id])
    ActiveRecord::Base.connection.execute(sql)

    sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?)"
    sql = prepare_sql(sql,[role_id, role_id])
    ActiveRecord::Base.connection.execute(sql)
  end


  # 刷新业务对像数据权限访问控制
  def refresh_business_object(bo_id)
    sql = "DELETE FROM irm_data_accesses_t WHERE business_object_id = ?"
    sql = prepare_sql(sql,[bo_id])
    ActiveRecord::Base.connection.execute(sql)

    sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v WHERE business_object_id = ?"
    sql = prepare_sql(sql,[bo_id])
    ActiveRecord::Base.connection.execute(sql)
  end


  # 刷新数据访问权限
  def refresh_data_access(org_id,business_object_id)
    if  org_id.present?
      sql = "DELETE FROM irm_data_accesses_t WHERE business_object_id=? source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?)"
      sql = prepare_sql(sql,[business_object_id,org_id, org_id])
      ActiveRecord::Base.connection.execute(sql)

      sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v WHERE business_object_id=? source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_id = ?)"
      sql = prepare_sql(sql,[business_object_id,org_id, org_id])
      ActiveRecord::Base.connection.execute(sql)
    else
      refresh_business_object(business_object_id)
    end
  end


  def refresh_data_share_rule(rule,origin_rule=nil)
    if origin_rule.present?
      sql = "DELETE FROM irm_data_accesses_t WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE (source_type= ? AND source_id = ?) OR (source_type= ? AND source_id = ?)) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE (source_type= ? AND source_id = ?) OR (source_type= ? AND source_id = ?))"
      sql = prepare_sql(sql,[rule[:source_type], rule[:source_id],origin_rule[:source_type], origin_rule[:source_id], rule[:target_type], rule[:target_id], origin_rule[:target_type], origin_rule[:target_id]])
      ActiveRecord::Base.connection.execute(sql)

      sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE (source_type= ? AND source_id = ?) OR (source_type= ? AND source_id = ?)) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE (source_type= ? AND source_id = ?) OR (source_type= ? AND source_id = ?))"
      sql = prepare_sql(sql,[rule[:source_type], rule[:source_id],origin_rule[:source_type], origin_rule[:source_id], rule[:target_type], rule[:target_id], origin_rule[:target_type], origin_rule[:target_id]])
      ActiveRecord::Base.connection.execute(sql)
    else
      sql = "DELETE FROM irm_data_accesses_t WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_type= ? AND source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_type= ? AND source_id = ?)"
      sql = prepare_sql(sql,[rule[:source_type], rule[:source_id], rule[:target_type], rule[:target_id]])
      ActiveRecord::Base.connection.execute(sql)

      sql = "INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v WHERE source_person_id  IN (SELECT person_id FROM irm_person_relations_v WHERE source_type= ? AND source_id = ?) OR target_person_id IN (SELECT person_id FROM irm_person_relations_v WHERE source_type= ? AND source_id = ?)"
      sql = prepare_sql(sql,[rule[:source_type], rule[:source_id], rule[:target_type], rule[:target_id]])
      ActiveRecord::Base.connection.execute(sql)
    end
  end

  private
  def prepare_sql(sql,binds)
    sql.gsub("?"){ ActiveRecord::Base.sanitize(*binds.shift) }
  end
end