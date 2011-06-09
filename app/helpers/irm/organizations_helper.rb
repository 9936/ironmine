module Irm::OrganizationsHelper
  def available_organization(company_id=nil)
    if company_id
      organizations = Irm::Organization.enabled.multilingual.query_by_company_id(company_id)
    else
      organizations = Irm::Organization.enabled.multilingual
    end
    organizations.collect{|i| [i[:name],i.id]}
  end

  def current_organization(company_id)
    Irm::Organization.query_by_company_id(company_id).
                      query_by_status_code("ENABLED").multilingual
  end

  def current_person_accessible_organizations_full
    accesses = Irm::CompanyAccess.query_by_person_id(Irm::Person.current.id).collect{|c| c.accessable_company_id}
    accessable_organizations = Irm::Organization.multilingual.query_wrap_info(I18n.locale).enabled.where("#{Irm::Organization.table_name}.company_id IN (?)", accesses)
    accessable_organizations.collect{|p| [p[:company_name] + "-" + p[:name], p.id]}
  end
end
