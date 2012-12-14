module Icm::ExternalSystemGroupsHelper
  def concat_system_groups(sid)
    rel = Irm::Group.multilingual.
        joins(",#{Icm::SupportGroup.table_name} sg").
        joins(",#{Icm::ExternalSystemGroup.table_name} esg").
        where("esg.external_system_id = ?", sid).
        where("esg.support_group_id = sg.id").
        where("sg.group_id = #{Irm::Group.table_name}.id").collect{|p| p[:name]}
    if rel
      return rel.join(",")
    else
      return ""
    end
  end

  def system_support_groups_ids(sid)
    rel = Irm::Group.multilingual.
        joins(",#{Icm::SupportGroup.table_name} sg").
        joins(",#{Icm::ExternalSystemGroup.table_name} esg").
        where("esg.external_system_id = ?", sid).
        where("esg.support_group_id = sg.id").
        where("sg.group_id = #{Irm::Group.table_name}.id").collect{|p| p[:id]}
    return rel
  end
end
