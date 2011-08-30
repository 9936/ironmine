module Icm::SupportGroupsHelper
  def support_group_duel_types(exclude=[])
    duel_types(exclude)+[[Irm::BusinessObject.class_name_to_meaning(Slm::ServiceCatalog.name),Irm::BusinessObject.class_name_to_code(Slm::ServiceCatalog.name)]]
  end

  def support_group_duel_values(exclude=[])
    values = duel_values(exclude)
    type_code = Irm::BusinessObject.class_name_to_code(Slm::ServiceCatalog.name)
    type_name = Irm::BusinessObject.class_name_to_meaning(Slm::ServiceCatalog.name)
    values += Slm::ServiceCatalog.multilingual.enabled.collect{|o| ["#{type_name}:#{o[:name]}","#{type_code}##{o.id}",{:type=>type_code,:query=>o[:name]}]}
    values
  end
end
