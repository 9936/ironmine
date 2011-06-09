module Irm::CompaniesHelper
  def available_company
    Irm::Company.query_by_status_code("ENABLED").multilingual.collect{|i|[i[:name],i.id]}
  end

  def current_person_accessible_companies_full
    accesses = Irm::CompanyAccess.query_by_person_id(Irm::Person.current.id).collect{|c| c.accessable_company_id}
    accessable_companies = Irm::Company.multilingual.query_by_ids(accesses)
    accessable_companies.collect{|p| [p[:name], p.id]}
  end
end