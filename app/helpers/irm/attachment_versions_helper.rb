module Irm::AttachmentVersionsHelper
  def list_requested_files
    if @requested_attachments && @requested_attachments.present?
      @requested_attachments
    end
  rescue
    ""
  end
end