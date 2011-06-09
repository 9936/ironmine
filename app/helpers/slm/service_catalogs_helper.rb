module Slm::ServiceCatalogsHelper
  def available_service_owner
     Irm::Person.real.collect{|p| ["#{p[:login_name]}(#{p[:person_name]})",p[:id]]}
  end

  def current_person_assessible_service_catalog_full
    servicecatalogs = Slm::ServiceCatalog.multilingual.with_external_system.enabled
    servicecatalogs.collect{|p| [p[:external_system_name] + '-' + p[:name], p.id]}
  end
end
