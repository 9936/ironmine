class Chm::ChangeApproval < ActiveRecord::Base
  set_table_name :chm_change_approvals

  validates_presence_of :person_id,:change_request_id,:approve_status

  # approve_status 分为以下几个审批状态 ASSIGNED 审批中 APPROVING 已经审批 APPROVED 审批通过 APPROVE 审批拒绝 REJECT


  query_extend

  scope :with_person,lambda{|language|
    joins("JOIN #{Irm::Person.table_name} people ON  people.id = #{table_name}.person_id").
    joins("LEFT OUTER JOIN #{Irm::Organization.view_name} organization  ON  organization.id = people.organization_id AND organization.language = '#{language}'").
    select("people.full_name,people.email_address,organization.name organization_name")
  }


  def self.list_all
    select_all.with_person(I18n.locale)
  end

end
