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
end