class Irm::AttachmentMember < ActiveRecord::Base
  set_table_name :irm_attachment_members

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end
