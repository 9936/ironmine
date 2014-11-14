include ActionView::Helpers::SanitizeHelper

class Mam::MasterReply < ActiveRecord::Base
  set_table_name :mam_master_replies
  query_extend
  belongs_to :master
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_reply_person, lambda {
    joins(",#{Irm::Person.table_name} ip").where("ip.id = #{table_name}.created_by").select("ip.full_name reply_person_name")
  }

  scope :with_reply_br, lambda {
    select("REPLACE(#{table_name}.reply_content, '\r\n', '<BR>') reply_content_br")
  }
end
