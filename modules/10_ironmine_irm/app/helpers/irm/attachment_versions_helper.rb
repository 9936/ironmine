module Irm::AttachmentVersionsHelper
  def list_requested_files
    if @requested_attachments && @requested_attachments.present?
      @requested_attachments
    end
  rescue
    ""
  end

  def available_file_categories
    Irm::LookupValue.multilingual.query_by_lookup_type("SKM_FILE_CATEGORIES").order_id.collect{|p| [p[:meaning], p.id]}
  end

end