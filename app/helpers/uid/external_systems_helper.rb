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

  def ava_external_systems
    systems = Uid::ExternalSystem.multilingual.enabled
    systems.collect{|p| [p[:system_name], p.external_system_code]}
  end

  def ava_external_system_members
    selectable_options = []
#    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"]]

    #Person
    targets = current_person_accessible_people_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Person.name.underscore.gsub("\/","_"))}:#{a[0]}","P##{a[1]}",{:query=>a[0],:type=>"P"}]
    end

    selectable_options
  end

  def owned_external_system_members
    member_types = [[Irm::Person,"P"]]
    own_members = Uid::ExternalSystemPerson.where(:support_group_id => group_id, :status_code => Irm::Constant::ENABLED)

    members = []
    own_members.each do |member|
      member_type = member_types.detect{|i| i[0].name.eql?(member.source_type)}
      members<<"#{member_type[1]}##{member.source_id}"
    end

    members.join(",")
  end
end
