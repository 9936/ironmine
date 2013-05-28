module Skm::FileManagementsHelper
  def data_version_file_name(data)
    if data && data[:data_content_type].present? && data[:data_content_type] =~ /image\//
      link_to(data[:data_file_name],{:controller => "skm/file_managements", :action => "show",:id=>data[:attachment_id], :version_id => data[:id],:data_file_name=> data[:data_file_name]})
    else
      data[:data_file_name]
    end
  end

  def data_file_name(data)
    if data && data[:data_content_type].present? && data[:data_content_type] =~ /image\//
      link_to(data[:data_file_name],{:controller => "skm/file_managements", :action => "show",:id=>data[:id], :version_id => data[:version_id],:data_file_name=> data[:data_file_name]})
    else
      data[:data_file_name]
    end
  end

  def access_type_meaning(type)
    case type
      when "PRIVATE"
        return t(:lanel_skm_file_access_private)
      when "PUBLIC"
        return t(:label_skm_file_access_public)
      when "MEMBERS"
        return t(:label_skm_file_access_members)
      else
        return ""
    end
  end
end