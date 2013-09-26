class Irm::AttachmentFolder < ActiveRecord::Base
  set_table_name :irm_attachment_folders
  has_many :attachments
  query_extend
end
