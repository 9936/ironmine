module Irm::GroupMembersHelper
  def support_group_member_flag(person_id,support_group_code)
    support_group = Irm::GroupMember.query_by_person_id(person_id).
                                 query_by_support_group_code(support_group_code).first
    if support_group.blank?
      false
    else
      true
    end
  end


  def available_group_member(group_id)
    Irm::GroupMember.select("#{Irm::GroupMember.table_name}.person_id").with_person(Irm::Person.current.language_code).where(:group_id=>group_id).collect{|gp| [gp[:person_name],gp.person_id]}
  end
end
