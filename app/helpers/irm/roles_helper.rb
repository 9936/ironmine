module Irm::RolesHelper
  def available_role_types
    Irm::LookupValue.query_by_lookup_type("IRM_ROLE_TYPE").multilingual.collect{|m| [m[:meaning], m.lookup_code]}
  end
  def available_report_groups
    Irm::ReportGroup.multilingual.enabled.collect{|g| [g[:name], g.group_code]}
  end

  def available_roles
    Irm::Role.multilingual.enabled.collect{|m| [m[:name],m.id]}
  end

  def available_top_menu
    Irm::Menu.multilingual.top_menu.collect{|m| [m[:name],m[:menu_code]]}
  end

  def available_parent_role(role_id=nil)
    all_roles = Irm::Role.list_all
    return all_roles.collect{|m| [m[:name],m.id]} unless role_id.present?
    grouped_roles = all_roles.collect{|i| [i.id,i.report_to_role_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    proc = Proc.new{|parent_role_id|
      all_roles.delete_if{|i| i.id.to_s.eql?(parent_role_id.to_s)}
      if(grouped_roles[parent_role_id.to_s]&&grouped_roles[parent_role_id.to_s].any?)

        grouped_roles[parent_role_id.to_s].each do |r|
          all_roles.delete_if{|i| i.id.to_s.eql?(r[0])}
          proc.call(r[0])
        end
      end
    }
    proc.call(role_id)
    all_roles.collect{|m| [m[:name],m.id]}

  end
end