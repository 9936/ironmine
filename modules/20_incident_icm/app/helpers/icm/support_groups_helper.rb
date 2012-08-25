module Icm::SupportGroupsHelper
  def support_group_duel_types(exclude=[])
    duel_types = duel_types(exclude)
    duel_types << [Irm::BusinessObject.class_name_to_meaning(Icm::IncidentCategory.name),Irm::BusinessObject.class_name_to_code(Icm::IncidentCategory.name)]

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
