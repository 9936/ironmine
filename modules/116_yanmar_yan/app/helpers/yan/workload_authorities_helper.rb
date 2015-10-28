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

  def show_count_workload(current)
    type = Yan::WorkloadAuthority.first
    person = Irm::GroupMember.where("irm_group_members.person_id = ?", current.id)
      if type.ob_type.eql?("ORG") && current.organization_id.eql?(type.ob_id)
        flag = true
      elsif type.ob_type.eql?("GROUP") && person.group_id.eql?(type.ob_id)
        flag = true
      else
        flag = false
      end
      flag
  end
end