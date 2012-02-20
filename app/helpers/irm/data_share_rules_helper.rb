module Irm::DataShareRulesHelper
  def available_types(exclude=[])
    type_classes = [Irm::Organization.name,
                    Irm::OrganizationExplosion.name,
                    Irm::Role.name,
                    Irm::RoleExplosion.name,
                    Irm::Group.name
                    ]
    type_classes = type_classes-exclude
    types={}
    type_classes.each do |i|
       label=Irm::BusinessObject.class_name_to_meaning(i)
       value=Irm::BusinessObject.class_name_to_code(i)
        types.merge!(label=>value)
    end

    types

  end

  def available_access_level
    lookup("IRM_DATA_ACCESS_LEVEL")
  end
end
