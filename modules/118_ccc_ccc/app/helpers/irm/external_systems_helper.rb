module Irm::ExternalSystemsHelper
  def available_external_systems
     Irm::ExternalSystem.multilingual.enabled
  end

  def available_external_systems_with_person(person_id)
     Irm::ExternalSystem.multilingual.enabled.order_with_name.with_person(person_id)
  end

  def current_person_assessible_external_system_full(person_id=Irm::Person.current.id)
    systems = Irm::ExternalSystem.multilingual.order_with_name.with_person(person_id).enabled#.order("CONVERT( system_name USING gbk ) ")
    systems.collect{|p| [p[:system_name], p.id]}
  end

  def ava_external_systems
    systems = Irm::ExternalSystem.multilingual.enabled
    systems.collect{|p| [p[:system_name], p.id]}
  end

  def ava_external_systems_reports(person_id)
    selectable_options = []
    systems = Irm::ExternalSystem.multilingual.enabled.order_with_name.with_person(person_id)
    selectable_options << ["--- #{t(:actionview_instancetag_blank_option)} ---",""]
    selectable_options += systems.collect{|p| [p[:system_name], p[:id]]}
    selectable_options
  end

  def ava_status_reports
    selectable_options = []
    incident_statuses_scope = Icm::IncidentStatus.multilingual.with_phase.status_meaning
    selectable_options << ["--- #{t(:actionview_instancetag_blank_option)} ---",""]
    selectable_options += incident_statuses_scope.collect { |i| [i[:name],i.id] }
    selectable_options << [t(:label_reports_not_close_status),"no_close"]
    selectable_options
  end

  def ava_level_groups
    level_group_ids = []
    level_group_ids << Irm::Group.where("parent_group_id = ''").first().id
    Irm::Group.where(:parent_group_id=>level_group_ids[0]).each do |ig|
      level_group_ids << ig.id
    end

    level_groups_scope = Irm::Group.multilingual.where(:id=>level_group_ids)

    selectable_options = []
    selectable_options << ["--- #{t(:actionview_instancetag_blank_option)} ---",""]
    selectable_options += level_groups_scope.collect { |i| [i[:name],i.id] }
    selectable_options
  end

  def ava_module_groups
    level_group_ids = []
    level_group_ids << Irm::Group.where("parent_group_id = ''").first().id
    Irm::Group.where(:parent_group_id=>level_group_ids[0]).each do |ig|
      level_group_ids << ig.id
    end

    selectable_options = []
    selectable_options << ["--- #{t(:actionview_instancetag_blank_option)} ---",""]
    module_groups_scope = Irm::Group.multilingual.where("irm_groups.id not in (?)",level_group_ids)
    selectable_options += module_groups_scope.collect { |i| [i[:description],i[:description]] }
    selectable_options.uniq!
  end

  def ava_groups
    level_group_ids = []
    temp_level_group_ids = Irm::Group.where("parent_group_id = ''").collect { |i| i.id }
    Irm::Group.where(:parent_group_id=>temp_level_group_ids).each do |ig|
      level_group_ids << ig.id
    end

    selectable_options = []
    selectable_options << ["--- #{t(:actionview_instancetag_blank_option)} ---",""]
    groups_scope = Irm::Group.multilingual.where("irm_groups.id not in (?)",level_group_ids).order("name ASC")
    selectable_options += groups_scope.collect { |i| [i[:name],i.id] }
    selectable_options
  end

  def ava_external_system_members
    selectable_options = []

    #Person
    targets = current_person_accessible_people_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Person.name.underscore.gsub("\/","_"))}:#{a[0]}","P##{a[1]}",{:query=>a[0],:type=>"P"}]
    end

    selectable_options
  end

  def owned_external_system_members
    member_types = [[Irm::Person,"P"]]
    own_members = Irm::ExternalSystemPerson.where(:support_group_id => group_id, :status_code => Irm::Constant::ENABLED)

    members = []
    own_members.each do |member|
      member_type = member_types.detect{|i| i[0].name.eql?(member.source_type)}
      members<<"#{member_type[1]}##{member.source_id}"
    end

    members.join(",")
  end


  def external_system_duel_values
    values = []
    values +=Irm::ExternalSystem.enabled.multilingual.collect.collect{|i| [i[:system_name],i.id,{:type=>"",:query=>i[:system_name]}]}
  end

  def accessable_external_system_duel_values
    values = []
    values +=Irm::ExternalSystem.with_person(Irm::Person.current.id).
        enabled.order_with_name.multilingual.collect.collect{|i| [i[:system_name],i.id,{:type=>"",:query=>i[:system_name]}]}
  end

  def external_system_duel_type
    [Irm::ExternalSystem.name].collect{|i| [Irm::BusinessObject.class_name_to_meaning(i),""]}
  end

  def profile_name(person_id,system_id)
    system_person = Irm::ExternalSystemPerson.where(:person_id=> person_id, :external_system_id=>system_id).first
    if system_person and system_person.system_profile_id
      Irm::Profile.multilingual.find(system_person.system_profile_id)[:name]
    else
      ''
    end
  end

  def available_projectTypes
    all_projectTypes = Ccc::ProjectType.enabled.multilingual
    all_projectTypes.collect{|i|[i[:name],i.id]}
  end

  def available_priceTypes
    all_priceTypes = Ccc::PriceType.enabled.multilingual
    all_priceTypes.collect{|i|[i[:name],i.id]}
  end

end
