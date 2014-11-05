module Icm::SupportGroupsHelper
  def support_group_duel_types(exclude=[])
    duel_types(exclude)
    #duel_types << [Irm::BusinessObject.class_name_to_meaning(Icm::IncidentCategory.name),
    #               Irm::BusinessObject.class_name_to_code(Icm::IncidentCategory.name)]
  end

  #获取分派处理人名
  def assign_person_name(person_id)
    Irm::Person.query_person_name(person_id).first.person_name
  end

  def support_name(group_id)
    Irm::Group.multilingual.query(group_id).first[:name]
  end

  def look_up_meaning(type, code)
    Irm::LookupValue.get_meaning(type, code)
  end

  #没有支持组的组
  def not_support_groups
    not_support_groups = Irm::Group.enabled.multilingual.where("NOT EXISTS (SELECT group_id FROM #{Icm::SupportGroup.table_name} WHERE #{Irm::Group.table_name}.id = #{Icm::SupportGroup.table_name}.group_id)")
    not_support_groups.collect{|i|[i[:name],i.id]}
  end

  def has_support_groups
    has_support_groups = Irm::Group.enabled.multilingual.where("EXISTS (SELECT group_id FROM #{Icm::SupportGroup.table_name} WHERE #{Irm::Group.table_name}.id = #{Icm::SupportGroup.table_name}.group_id)")
    has_support_groups.collect{|i|[i[:name],i.id]}
  end

  def support_group_duel_values(exclude=[])
    values = duel_values(exclude)
    type_code = Irm::BusinessObject.class_name_to_code(Icm::IncidentCategory.name)
    type_name = Irm::BusinessObject.class_name_to_meaning(Icm::IncidentCategory.name)
    values += Icm::IncidentCategory.multilingual.enabled.collect{|o| ["#{type_name}:#{o[:name]}","#{type_code}##{o.id}",{:type=>type_code,:query=>o[:name]}]}
    values
  end

  def ava_supporters
    supporters = Irm::Person.enabled.
        select("#{Irm::Person.table_name}.*").
        where(%Q"EXISTS(SELECT * FROM #{Icm::SupportGroup.table_name} sg, #{Irm::GroupMember.table_name} gm
                 WHERE sg.group_id = gm.group_id
                 AND gm.person_id = #{Irm::Person.table_name}.id
                 AND sg.oncall_flag = ?)", Irm::Constant::SYS_YES).order("CONVERT(full_name USING gbk ) ")
    supporters.collect{|p| [p.full_name + "(" + p.login_name + ")", p.id]}
  end

  def support_groups_with_external_system(external_system_id, exclude_support_group_ids = [])
    groups = Irm::Group.enabled.multilingual.
        where(%Q(EXISTS (
                    SELECT group_id
                    FROM #{Icm::SupportGroup.table_name}, #{Icm::ExternalSystemGroup.table_name}
                    WHERE #{Irm::Group.table_name}.id = #{Icm::SupportGroup.table_name}.group_id
                    AND #{Icm::ExternalSystemGroup.table_name}.support_group_id = #{Icm::SupportGroup.table_name}.id
                    AND #{Icm::ExternalSystemGroup.table_name}.external_system_id = ?
                    AND #{Icm::SupportGroup.table_name}.id NOT IN (?))), external_system_id, exclude_support_group_ids + [""])
    groups.collect{|i|[i[:name],i.id]}
  end

  def support_groups_with_external_system_person(external_system_id, person_id, exclude_support_group_ids = [])
    groups = Irm::Group.enabled.multilingual.
        where(%Q(EXISTS (
                    SELECT group_id
                    FROM #{Icm::SupportGroup.table_name}, #{Icm::ExternalSystemGroup.table_name}
                    WHERE #{Irm::Group.table_name}.id = #{Icm::SupportGroup.table_name}.group_id
                    AND #{Icm::ExternalSystemGroup.table_name}.support_group_id = #{Icm::SupportGroup.table_name}.id
                    AND #{Icm::ExternalSystemGroup.table_name}.external_system_id = ?
                    AND #{Icm::SupportGroup.table_name}.id NOT IN (?))), external_system_id, exclude_support_group_ids + [""]).
        where(%Q(EXISTS (
                    SELECT group_id FROM #{Irm::GroupMember.table_name} gm
                    WHERE gm.group_id = #{Irm::Group.table_name}.id
                    AND gm.person_id = ?)), person_id)
    groups.collect{|i|[i[:name],i.id]}
  end

  def support_groups_with_person(person_id, exclude_support_group_ids = [])
    groups = Irm::Group.enabled.multilingual.
        where(%Q(EXISTS (
                    SELECT group_id
                    FROM #{Icm::SupportGroup.table_name}, #{Icm::ExternalSystemGroup.table_name}
                    WHERE #{Irm::Group.table_name}.id = #{Icm::SupportGroup.table_name}.group_id
                    AND #{Icm::ExternalSystemGroup.table_name}.support_group_id = #{Icm::SupportGroup.table_name}.id
                    AND #{Icm::SupportGroup.table_name}.person_id = ?
                    AND #{Icm::SupportGroup.table_name}.id NOT IN (?))), person_id, exclude_support_group_ids + [""])

    groups.collect{|i|[i[:name],i.id]}
  end

  def support_groups_list
    groups = Icm::SupportGroup.joins(", icm_support_groups_vl isgv").where("isgv.id = #{Icm::SupportGroup.table_name}.id").where("isgv.language = 'en'").select("isgv.name, isgv.id")
    groups.collect{|i|[i[:name],i.id]}
  end

end
