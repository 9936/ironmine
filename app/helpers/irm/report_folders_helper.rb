module Irm::ReportFoldersHelper
  def available_report_folder_access_type
    Irm::LookupValue.query_by_lookup_type("IRM_REPORT_FOLDER_ACCESS_TYPE").multilingual.order_id.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def available_report_folder_member_type
    Irm::LookupValue.query_by_lookup_type("IRM_REPORT_FOLDER_MEMBER_TYPE").multilingual.order_id.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def available_report_folder_viewer_type
    [Irm::Person.name,Irm::Role.name].collect{|i| [Irm::BusinessObject.class_name_to_meaning(i),Irm::BusinessObject.class_name_to_code(i)]}
  end

  def available_report_folder_viewer
    values = []
    values +=Irm::Person.real.collect{|p| ["#{Irm::BusinessObject.class_name_to_meaning(Irm::Person.name)}:#{p.full_name}","#{Irm::BusinessObject.class_name_to_code(Irm::Person.name)}##{p.id}",{:type=>Irm::BusinessObject.class_name_to_code(Irm::Person.name),:query=>p.full_name}]}
    values +=Irm::Role.multilingual.enabled.collect{|r| ["#{Irm::BusinessObject.class_name_to_meaning(Irm::Role.name)}:#{r[:name]}","#{Irm::BusinessObject.class_name_to_code(Irm::Role.name)}##{r.id}",{:type=>Irm::BusinessObject.class_name_to_code(Irm::Role.name),:query=>r[:name]}]}
    values
  end

  def available_report_folder_json
    folders = Irm::ReportFolder.multilingual.collect{|i| {:id=>i.id ,:type=>"folder",:text=>i[:name],:folder_id=>i.id,:leaf=>true,:iconCls=>"x-tree-icon-parent"}}
    root_folder = {:id=>"",:type=>"root",:folder_id=>"",:text=>t(:label_irm_report_folder_all),:draggable=>false,:leaf=>false,:expanded=>true}
    root_folder[:children] =  folders
    content_for(:page_script,"var reportFolderTreeData = #{root_folder.to_json};".html_safe)
  end

  def available_report_folder
    Irm::ReportFolder.multilingual.collect{|i| [i[:name],i.id]}
  end

  def available_current_report_folder
    Irm::Person.current.report_folders.collect{|i| [i[:name],i.id]}
  end


  def report_folder_member_value(report_folder_id)
    if report_folder_id
      return Irm::ReportFolderMember.where(:report_folder_id=>report_folder_id).collect{|i| "#{Irm::BusinessObject.class_name_to_code(i[:member_type])}##{i.member_id}"}.join(",")
    end
  end
end
