module Skm::ColumnsHelper
  def own_skm_column_accesses(column_id)
    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Profile,"R"]]
    column_accesses = Skm::ColumnAccess.where(:column_id => column_id, :status_code => Irm::Constant::ENABLED)
    accesses = []
    column_accesses.each do |access|
      access_type = access_types.detect{|i| i[0].name.eql?(access.source_type)}
      accesses<<"#{access_type[1]}##{access.source_id}"
    end
    accesses.join(",")
  end

  def ava_skm_column_accesses
    selectable_options = []
#    access_types = [[Irm::Company,"C"],[Irm::Organization,"O"],[Irm::Department,"D"],[Irm::Role,"R"]]

    #Company
    accesses = current_person_accessible_companies_full
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Company.name.underscore.gsub("\/","_"))}:#{a[0]}","C##{a[1]}",{:query=>a[0],:type=>"C"}]
    end
    #Organization
    accesses = current_person_accessible_organizations_full
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Organization.name.underscore.gsub("\/","_"))}:#{a[0]}","O##{a[1]}",{:query=>a[0],:type=>"O"}]
    end
    #Department
    accesses = current_person_accessible_departments_full
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Department.name.underscore.gsub("\/","_"))}:#{a[0]}","D##{a[1]}",{:query=>a[0],:type=>"D"}]
    end
    #Profile
    accesses = available_profile
    accesses.each do |a|
      selectable_options << ["#{t("label_"+Irm::Profile.name.underscore.gsub("\/","_"))}:#{a[0]}","R##{a[1]}",{:query=>a[0],:type=>"R"}]
    end

    selectable_options
  end
end