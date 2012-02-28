module Irm::OrganizationInfosHelper
  def filename(attachment_id)
    attachment =  Irm::AttachmentVersion.find(attachment_id)
    unless attachment.nil?
      "<a target='_blank' href='#{attachment.data.url}'>#{attachment.data.original_filename}</a>".html_safe if attachment[:data_file_name].present?
    else
      'no attachment'
    end
  end
end
