module Icm::GroupAssignmentsHelper
  def available_ass_people
    Irm::Person.where("1=1").collect{|p|[p.name, p.id]}
  end

  def available_ass_support_groups
    Irm::SupportGroup.multilingual.where("oncall_group_flag = ?", Irm::Constant::SYS_YES).enabled.collect{|p|[p[:name], p[:group_code]]}
  end

  def temp_ava_organizations_edit(company_id)
    Irm::Organization.multilingual.enabled.where("#{Irm::Organization.table_name}.company_id = ?", company_id).collect{|p|[p[:name], p[:id]]}
  end

  def temp_ava_departments_edit(organization_id)
    Irm::Department.multilingual.enabled.where("#{Irm::Department.table_name}.organization_id = ?", organization_id).collect{|p|[p[:name], p[:id]]}
  end

  def temp_ava_people_edit(department_id)
    Irm::Person.where("#{Irm::Person.table_name}.department_id = ?", department_id).collect{|p|[p.name, p.id]}
  end

  def ava_group_assignment_targets
    selectable_options = []
#    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"]]

    #Company
    targets = current_person_accessible_companies_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Company.name.underscore.gsub("\/","_"))}:#{a[0]}","C##{a[1]}",{:query=>a[0],:type=>"C"}]
    end
    #Organization
    targets = current_person_accessible_organizations_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Organization.name.underscore.gsub("\/","_"))}:#{a[0]}","O##{a[1]}",{:query=>a[0],:type=>"O"}]
    end
    #Department
    targets = current_person_accessible_departments_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Department.name.underscore.gsub("\/","_"))}:#{a[0]}","D##{a[1]}",{:query=>a[0],:type=>"D"}]
    end
    #Person
    targets = current_person_accessible_people_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Irm::Person.name.underscore.gsub("\/","_"))}:#{a[0]}","P##{a[1]}",{:query=>a[0],:type=>"P"}]
    end
    #External System
    targets = current_person_assessible_external_system_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Uid::ExternalSystem.name.underscore.gsub("\/","_"))}:#{a[0]}","E##{a[1]}",{:query=>a[0],:type=>"E"}]
    end
    #Service Catalog
    targets = current_person_assessible_service_catalog_full
    targets.each do |a|
      selectable_options << ["#{t("label_"+Slm::ServiceCatalog.name.underscore.gsub("\/","_"))}:#{a[0]}","S##{a[1]}",{:query=>a[0],:type=>"S"}]
    end
    selectable_options
  end

  def own_group_assignment_targets(assignment_id)
    assignment_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Person,"P"],[Uid::ExternalSystem, "E"],[Slm::ServiceCatalog, "S"]]
    own_assignments = Icm::GroupAssignmentDetail.where(:group_assignment_id => assignment_id, :status_code => Irm::Constant::ENABLED)

    assignments = []
    own_assignments.each do |assignment|
      assignment_type = assignment_types.detect{|i| i[0].name.eql?(assignment.source_type)}
      assignments<<"#{assignment_type[1]}##{assignment.source_id}"
    end

    assignments.join(",")
  end

end