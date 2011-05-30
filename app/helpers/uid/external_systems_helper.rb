module Uid::ExternalSystemsHelper
  def available_external_systems
     Uid::ExternalSystem.multilingual.enabled
  end

  def available_external_systems_with_person(person_id)
     Uid::ExternalSystem.multilingual.enabled.with_person(person_id)
  end
end
