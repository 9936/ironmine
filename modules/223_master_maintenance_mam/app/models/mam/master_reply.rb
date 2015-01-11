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

  def support_group_member_ids
    return @support_group_member_ids if @support_group_member_ids
    return nil if self.master.support_group_id.nil?
    @support_group_member_ids = Irm::Person.
        joins(",#{Irm::GroupMember.table_name} gm").
        joins(",#{Icm::SupportGroup.table_name} sg").
        where("gm.group_id = sg.group_id").
        where("gm.person_id = #{Irm::Person.table_name}.id").
        where("sg.id = ?", self.master.support_group_id).
        enabled.collect(&:id)
  end

  def master_support_person_id
    self.master.support_person_id
  end

  def master_submitted_by
    self.master.submitted_by
  end

end
