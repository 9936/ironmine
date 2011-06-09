module Uid::ExternalSystemsHelper
  def available_external_systems
     Uid::ExternalSystem.multilingual.enabled
  end

  def available_external_systems_with_person(person_id)
     Uid::ExternalSystem.multilingual.enabled.with_person(person_id)
  end

  def current_person_assessible_external_system_full
    systems = Uid::ExternalSystem.multilingual.enabled
    systems.collect{|p| [p[:system_name], p.id]}
  end
end
