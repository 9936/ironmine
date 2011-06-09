class Icm::GroupAssignment < ActiveRecord::Base
  set_table_name :icm_group_assignments
  has_many :group_assignment_details,:dependent => :destroy
  validates_uniqueness_of :support_group_code

  scope :with_support_group, lambda {
    select("sgt.name support_group_name,"+
           "v2.name company_name,v3.name organization_name,"+
           "v4.meaning support_role_name,sg.vendor_group_flag,sg.oncall_group_flag").
    joins(",irm_companies_vl v2").
    joins(",irm_organizations_vl v3").
    joins(",irm_lookup_values_vl v4").
    joins(",#{Irm::SupportGroup.table_name} sg").
    joins(",#{Irm::SupportGroupsTl.table_name} sgt").
    where("v4.lookup_type='IRM_SUPPORT_ROLE' AND v4.lookup_code = sg.support_role_code AND "+
          "sg.company_id = v2.id AND v2.language=? AND "+
          "sg.organization_id = v3.id AND v3.language=? AND "+
          "v4.language=?",
          I18n.locale,I18n.locale,I18n.locale).
    where("#{table_name}.support_group_code = sg.group_code").
    where("sgt.support_group_id = sg.id").where("sgt.language = ?", I18n.locale)
  }

  scope :assignable,lambda{
    joins("JOIN #{Irm::SupportGroup.table_name}  ON #{Irm::SupportGroup.table_name}.group_code = #{table_name}.support_group_code AND #{Irm::SupportGroup.table_name}.oncall_group_flag = 'Y' AND #{Irm::SupportGroup.table_name}.status_code = 'ENABLED'")
  }

  scope :query_by_support_groups, lambda{|support_group_id|
    where("#{table_name}.support_group_code = ?", support_group_id)
  }

  scope :list_all, lambda {
    select("#{table_name}.*").with_support_group
  }
end