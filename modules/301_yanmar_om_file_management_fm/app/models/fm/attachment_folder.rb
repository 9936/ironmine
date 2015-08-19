class Fm::AttachmentFolder < ActiveRecord::Base
  set_table_name :fm_attachment_folders
  has_many :attachments
  query_extend
end
