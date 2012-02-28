module Irm::OrganizationInfosHelper
  def filename(attachment_id)
    attachment =  Irm::AttachmentVersion.find(attachment_id)
    unless attachment.nil?
      "<a target='_blank' href='#{attachment.data.url}'>#{attachment.data.original_filename}</a>".html_safe if attachment[:data_file_name].present?
    else
      'no attachment'
    end
  end

  def file_operation(attachment_id)
    attachment =  Irm::AttachmentVersion.find(attachment_id)
    unless attachment.nil?
       "<span id='modify_file'><a href='javascript:void(0);'>#{t(:label_irm_edit_attachment)}</a></span> | <span id='delete_file' attachment_id='#{attachment_id}'><a href='javascript:void(0)'>#{t(:delete)} %></a></span>"
    end
  end
end
