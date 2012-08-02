module Irm::DuelSelectHelper
  def duel_types(exclude=[])
    type_classes = [Irm::Organization.name,
                    Irm::OrganizationExplosion.name,
                    Irm::Role.name,
                    Irm::RoleExplosion.name,
                    Irm::Group.name,
                    Irm::GroupExplosion.name,
                    Irm::ExternalSystem.name,
                    Irm::Person.name]
    type_classes = type_classes-exclude
    type_classes.collect{|i| [Irm::BusinessObject.class_name_to_meaning(i),Irm::BusinessObject.class_name_to_code(i)]}

  end


  def duel_values(exclude=[])
    type_classes = [Irm::Organization.name,
                    Irm::OrganizationExplosion.name,
                    Irm::Role.name,
                    Irm::RoleExplosion.name,
                    Irm::Group.name,
                    Irm::GroupExplosion.name,
                    Irm::ExternalSystem.name,
                    Irm::Person.name]

    type_classes = type_classes-exclude
    values = []

    if type_classes.include?(Irm::Organization.name)
      label_name =Irm::BusinessObject.class_name_to_meaning(Irm::Organization.name)
      code = Irm::BusinessObject.class_name_to_code(Irm::Organization.name)
      values +=Irm::Organization.enabled.multilingual.collect{|i| ["#{label_name}:#{i[:name]}","#{code}##{i.id}",{:type=>code,:query=>i[:name]}]}
    end

    if type_classes.include?(Irm::OrganizationExplosion.name)
      label_name =Irm::BusinessObject.class_name_to_meaning(Irm::OrganizationExplosion.name)
      code = Irm::BusinessObject.class_name_to_code(Irm::OrganizationExplosion.name)
      values +=Irm::Organization.enabled.multilingual.collect{|i| ["#{label_name}:#{i[:name]}","#{code}##{i.id}",{:type=>code,:query=>i[:name]}]}
    end

    if type_classes.include?(Irm::Role.name)
      label_name =Irm::BusinessObject.class_name_to_meaning(Irm::Role.name)
      code = Irm::BusinessObject.class_name_to_code(Irm::Role.name)
      values +=Irm::Role.enabled.multilingual.collect{|i| ["#{label_name}:#{i[:name]}","#{code}##{i.id}",{:type=>code,:query=>i[:name]}]}
    end

    if type_classes.include?(Irm::RoleExplosion.name)
      label_name =Irm::BusinessObject.class_name_to_meaning(Irm::RoleExplosion.name)
      code = Irm::BusinessObject.class_name_to_code(Irm::RoleExplosion.name)
      values +=Irm::Role.enabled.multilingual.collect{|i| ["#{label_name}:#{i[:name]}","#{code}##{i.id}",{:type=>code,:query=>i[:name]}]}
    end

    if type_classes.include?(Irm::Group.name)
      label_name =Irm::BusinessObject.class_name_to_meaning(Irm::Group.name)
      code = Irm::BusinessObject.class_name_to_code(Irm::Group.name)
      values +=Irm::Group.enabled.multilingual.collect{|i| ["#{label_name}:#{i[:name]}","#{code}##{i.id}",{:type=>code,:query=>i[:name]}]}
    end


    if type_classes.include?(Irm::GroupExplosion.name)
      label_name =Irm::BusinessObject.class_name_to_meaning(Irm::GroupExplosion.name)
      code = Irm::BusinessObject.class_name_to_code(Irm::GroupExplosion.name)
      values +=Irm::Group.enabled.multilingual.collect{|i| ["#{label_name}:#{i[:name]}","#{code}##{i.id}",{:type=>code,:query=>i[:name]}]}
    end

    if type_classes.include?(Irm::ExternalSystem.name)
      label_name =Irm::BusinessObject.class_name_to_meaning(Irm::ExternalSystem.name)
      code = Irm::BusinessObject.class_name_to_code(Irm::ExternalSystem.name)
      values +=Irm::ExternalSystem.enabled.multilingual.collect.collect{|i| ["#{label_name}:#{i[:system_name]}","#{code}##{i.id}",{:type=>code,:query=>i[:name]}]}
    end

    if type_classes.include?(Irm::Person.name)
      label_name =Irm::BusinessObject.class_name_to_meaning(Irm::Person.name)
      code = Irm::BusinessObject.class_name_to_code(Irm::Person.name)
      values +=Irm::Person.real.collect.collect{|i| ["#{label_name}:#{i[:full_name]}","#{code}##{i.id}",{:type=>code,:query=>i[:full_name]}]}
    end

    values

  end

  def duel_meaning(value,options)
    options_hash = {}
    options.each{|i| options_hash.merge!(i[1]=>i[0])}
    value_array = value.split(",").compact
    meaning = []
    value_array.each{|i| meaning<<options_hash[i]}
    meaning
  end

end