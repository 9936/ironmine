module Yan::WorkloadAuthoritiesHelper
  def has_authority(scope_name)
    auth = false
    if scope_name.eql?("YISS")
      auth = Yan::WorkloadAuthority.with_object_type_and_id("ORG", "001q00091nQ3qKZLDIeYoi").any?
    elsif scope_name.eql?("HAND")
      auth = Yan::WorkloadAuthority.with_object_type_and_id("ORG", "001q00091nQ3qKZLEmXAdE").any?
    elsif scope_name.eql?("SD")
      auth = Yan::WorkloadAuthority.with_object_type_and_id("GROUP", "001400091nvxvi9mGSGGq8").any?
    end
    auth
  end

  #与设置中的选项结合判断当前用户是否显示记录工时的框框
  def show_count_workload(current)
    type = Yan::WorkloadAuthority.first
    num = Yan::WorkloadAuthority.count
    person = Irm::GroupMember.where("irm_group_members.person_id = ? and irm_group_members.group_id = ?", current.id,"001400091nvxvi9mGSGGq8").first
    flag = nil
      if num == 2 && (current.organization_id.eql?("001q00091nQ3qKZLEmXAdE") || current.organization_id.eql?("001q00091nQ3qKZLDIeYoi"))
          flag = true
      elsif num == 1 && type.ob_type.eql?("ORG") && current.organization_id.eql?(type.ob_id)
        flag = true
      elsif num == 1 && type.ob_type.eql?("GROUP") && !person.nil?
        if person.group_id.eql?(type.ob_id)
          flag = true
        end
      else
        flag = false
      end
      flag
  end
end