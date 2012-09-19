module Icm::SupportGroupsHelper
  def support_group_duel_types(exclude=[])
    duel_types = duel_types(exclude)
    duel_types << [Irm::BusinessObject.class_name_to_meaning(Icm::IncidentCategory.name),Irm::BusinessObject.class_name_to_code(Icm::IncidentCategory.name)]
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
    supporters = Irm::Person.
        enabled.
        select("#{Irm::Person.table_name}.*").
        where(%Q"EXISTS(SELECT * FROM #{Icm::SupportGroup.table_name} sg, #{Irm::GroupMember.table_name} gm
                 WHERE sg.group_id = gm.group_id
                 AND gm.person_id = #{Irm::Person.table_name}.id
                 AND sg.oncall_flag = ?)", Irm::Constant::SYS_YES)
    supporters.collect{|p| [p.full_name, p.id]}
  end
end
