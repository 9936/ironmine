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

end