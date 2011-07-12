module Irm::KanbansHelper
  def ava_kanban_ranges
    selectable_options = []

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
    #Role
    accesses = ava_access_roles
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Role.name.underscore.gsub("\/","_"))}:#{a[0]}","R##{a[1]}",{:query=>a[0],:type=>"R"}]
    end
    selectable_options
  end

  def own_kanban_ranges(kanban_id)
    assignment_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"],[Irm::Person,"P"]]
    own_assignments = Irm::KanbanRange.where(:kanban_id => kanban_id, :status_code => Irm::Constant::ENABLED)

    assignments = []
    own_assignments.each do |assignment|
      assignment_type = assignment_types.detect{|i| i[0].name.eql?(assignment.range_type)}
      assignments<<"#{assignment_type[1]}##{assignment.range_id}"
    end

    assignments.join(",")
  end
end