include ActionView::Helpers::SanitizeHelper

class Mam::Master < ActiveRecord::Base
  set_table_name :mam_masters
  query_extend
  has_many :master_scs
  has_many :master_urs
  has_many :master_items
  has_many :master_replies

  validates_presence_of :system_id

  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_category, lambda{
    joins(",irm_lookup_values_vl lvmc").
        where("lvmc.language = 'en'").
        where("lvmc.lookup_code = #{table_name}.category").
        select("lvmc.meaning category_name")
  }

  scope :with_system, lambda{
    joins(",mam_systems ms").
        where("ms.id = #{table_name}.system_id").
        select("ms.system_name system_name")
  }

  scope :with_support_group, lambda{
    joins("LEFT OUTER JOIN icm_support_groups_vl isgv ON isgv.language = 'en' AND isgv.id = #{table_name}.support_group_id").
        select("isgv.name support_group_name")
  }

  scope :with_supporter, lambda{
    joins("LEFT OUTER JOIN irm_people ipsp ON ipsp.id = #{table_name}.support_person_id").
        select("ipsp.full_name supporter_name")
  }

  scope :with_submitted_by, lambda{
    joins(", irm_people ipsb").
        where("ipsb.id = #{table_name}.submitted_by").
        select("ipsb.full_name submitted_by_name")
  }

  scope :with_master_status, lambda{
    joins(",irm_lookup_values_vl lvms").
        where("lvms.language = 'en'").
        where("lvms.lookup_code = #{table_name}.master_status").
        where("lvms.lookup_type = 'MAM_STATUS'").
        select("lvms.meaning master_status_name")
  }

  def close?
    if self.master_status.eql?("MAM_CLOSE")
      return true
    else
      return false
    end
  end

  def assignable_to_person?(person_id)
    if Mam::SystemPerson.
        where("person_id = ?", person_id).
        where("system_id = ?", self.system_id).size > 0 &&
       Irm::GroupMember.
           joins(", icm_support_groups isgv").
           where("#{Irm::GroupMember.table_name}.group_id = isgv.group_id").
           where("#{Irm::GroupMember.table_name}.person_id = ? ", person_id).
           where("isgv.id = ?", self.support_group_id).size > 0 && !self.support_person_id.present?
      return true
    end
    return false
  end
end
