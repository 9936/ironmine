module Slm::ServiceCatalogsHelper
  def available_service_owner
     Irm::Person.real.collect{|p| ["#{p[:login_name]}(#{p[:full_name]})",p[:id]]}
  end

  def current_person_assessible_service_catalog_full
    servicecatalogs = Slm::ServiceCatalog.multilingual.with_external_system.enabled
    servicecatalogs.collect{|p| [p[:external_system_name] + '-' + p[:name], p.id]}
  end

  def accessable_external_system_duel_values
    values = []
    values +=Irm::ExternalSystem.with_person(Irm::Person.current.id).
        enabled.order_with_name.multilingual.collect.collect{|i| [i[:system_name],i.id,{:type=>"",:query=>i[:system_name]}]}
  end

  def external_system_duel_values
    values = []
    values +=Irm::ExternalSystem.
        enabled.order_with_name.multilingual.collect.collect{|i| [i[:system_name],i.id,{:type=>"",:query=>i[:system_name]}]}
  end


  def available_service_catalogs
    all_service_catalogs = Slm::ServiceCatalog.enabled.multilingual

    grouped_service_catalogs = all_service_catalogs.collect{|i| [i.id,i.parent_catalog_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    service_catalogs = {}
    all_service_catalogs.each do |ao|
      service_catalogs.merge!({ao.id=>ao})
    end
    leveled_service_catalogs = []

    proc = Proc.new{|parent_id,level|
      if(grouped_service_catalogs[parent_id.to_s]&&grouped_service_catalogs[parent_id.to_s].any?)

        grouped_service_catalogs[parent_id.to_s].each do |o|
          service_catalogs[o[0]].level = level
          leveled_service_catalogs << service_catalogs[o[0]]

          proc.call(service_catalogs[o[0]].id,level+1)
        end
      end
    }


    grouped_service_catalogs["blank"].each do |go|
      service_catalogs[go[0]].level = 1
      leveled_service_catalogs << service_catalogs[go[0]]
      proc.call(service_catalogs[go[0]].id,2)
    end if grouped_service_catalogs["blank"]

    leveled_service_catalogs.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}

  end


  def available_parentable_service_catalog(service_catalog_id=nil)
    unless service_catalog_id.present?
      return available_service_catalogs
    end

    all_service_catalogs = Slm::ServiceCatalog.enabled.parentable(service_catalog_id).multilingual

    grouped_service_catalogs = all_service_catalogs.collect{|i| [i.id,i.parent_catalog_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    service_catalogs = {}
    all_service_catalogs.each do |ao|
      service_catalogs.merge!({ao.id=>ao})
    end
    leveled_service_catalogs = []

    proc = Proc.new{|parent_id,level|
      if(grouped_service_catalogs[parent_id.to_s]&&grouped_service_catalogs[parent_id.to_s].any?)

        grouped_service_catalogs[parent_id.to_s].each do |o|
          service_catalogs[o[0]].level = level
          leveled_service_catalogs << service_catalogs[o[0]]

          proc.call(service_catalogs[o[0]].id,level+1)
        end
      end
    }


    grouped_service_catalogs["blank"].each do |go|
      service_catalogs[go[0]].level = 1
      leveled_service_catalogs << service_catalogs[go[0]]
      proc.call(service_catalogs[go[0]].id,2)
    end if grouped_service_catalogs["blank"]

    leveled_service_catalogs.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}

  end
end
