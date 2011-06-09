module Irm::DepartmentsHelper
  def available_department(organization_id=nil)
    if(organization_id)
      departments = Irm::Department.query_by_organization(organization_id).multilingual.enabled
    else
      departments = Irm::Department.multilingual.enabled
    end
    departments.collect{|i| [i[:name],i.id]}
  end

  def current_department(company_id,organization_id)
    Irm::Department.query_all_department(company_id,organization_id).query_by_status_code("ENABLED").multilingual
  end



  def current_person_accessible_departments_full
    accesses = Irm::CompanyAccess.query_by_person_id(Irm::Person.current.id).collect{|c| c.accessable_company_id}
#    accessable_companies = Irm::Company.multilingual.query_by_ids(accesses)
    departments = []
    accesses.each do |t|
      te = Irm::Department.multilingual.query_wrap_info(I18n.locale).enabled.where("#{Irm::Department.table_name}.company_id = ?", t)
      departments = departments + te if te.size > 0
    end

    departments = departments.uniq
    departments.collect{|p| [p[:company_name] +"-" +p[:organization_name] +"-" +p[:name], p.id]}
  end

end
