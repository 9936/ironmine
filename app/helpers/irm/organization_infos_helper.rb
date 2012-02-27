module Irm::OrganizationInfosHelper
  def filename(attachment_id)
    attachment =  Irm::AttachmentVersion.select("data_file_name").where("id" => attachment_id).first
    unless attachment.nil?
      attachment[:data_file_name] if attachment[:data_file_name].present?
    else
      'no attachment'
    end
  end
end
