module Irm::ReportFoldersHelper
  def available_report_folder_access_type
    [["Forbid","FORBID"],["Read Only","READ_ONLY"],["Read/Write","READ_WRITE"]]
  end

  def available_report_folder_member_type
    [["all people view","PUBLIC"],["Only Creator","PRIVATE"],["Only member","MEMBER"]]
  end
  # =========== for add_exists_action ==================================
  def available_report_folder_viewer_type
    [Irm::Person.name,Irm::Role.name].collect{|i| [Irm::BusinessObject.class_name_to_meaning(i),Irm::BusinessObject.class_name_to_code(i)]}
  end

  def available_report_folder_viewer
    values = []
    values +=Irm::Person.query_by_company_ids(Irm::Person.current.accessable_company_ids).collect{|p| ["#{Irm::BusinessObject.class_name_to_meaning(Irm::Person.name)}:#{p.full_name}","#{Irm::BusinessObject.class_name_to_code(Irm::Person.name)}##{p.id}",{:type=>Irm::BusinessObject.class_name_to_code(Irm::Person.name),:query=>p.full_name}]}
    values +=Irm::Role.multilingual.enabled.collect{|r| ["#{Irm::BusinessObject.class_name_to_meaning(Irm::Role.name)}:#{r[:name]}","#{Irm::BusinessObject.class_name_to_code(Irm::Role.name)}##{r.id}",{:type=>Irm::BusinessObject.class_name_to_code(Irm::Role.name),:query=>r[:name]}]}
    values
  end

  def available_report_folder
    Irm::ReportFolder.multilingual.collect{|i| [i[:name],i.id]}
  end

  def available_current_report_folder
    Irm::Person.current.report_folders.collect{|i| [i[:name],i.id]}
  end
end
