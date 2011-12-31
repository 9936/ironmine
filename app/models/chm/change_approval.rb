class Chm::ChangeApproval < ActiveRecord::Base
  set_table_name :chm_change_approvals

  validates_presence_of :person_id,:change_request_id,:approve_status

  belongs_to :change_request

  # approve_status 分为以下几个审批状态 ASSIGNED 审批中 APPROVING 已经审批 APPROVED 审批通过 APPROVE 审批拒绝 REJECT


  query_extend

  scope :with_person,lambda{|language|
    joins("JOIN #{Irm::Person.table_name} people ON  people.id = #{table_name}.person_id").
    joins("LEFT OUTER JOIN #{Irm::Organization.view_name} organization  ON  organization.id = people.organization_id AND organization.language = '#{language}'").
    select("people.full_name,people.email_address,organization.name organization_name")
  }

  # 查询出审批状态
  scope :with_approve_status,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} approve_status ON approve_status.lookup_type='CHANGE_APPROVE_STATUS' AND approve_status.lookup_code = #{table_name}.approve_status AND approve_status.language= '#{language}'").
    select(" approve_status.meaning approve_status_name")
  }

  scope :with_change_request,lambda{
    joins("JOIN #{Chm::ChangeRequest.table_name} ON #{table_name}.change_request_id = #{Chm::ChangeRequest.table_name}.id").
    select("#{Chm::ChangeRequest.table_name}.title")
  }


  def self.list_all
    select_all.with_approve_status(I18n.locale).with_person(I18n.locale)
  end


  #审批通过
  def reject
    self.approve_status="REJECT"
    self.approve_at= Time.now
    self.save

    self.class.where(:change_request_id=>self.change_request_id).update_all(:approve_status=>"REJECT")

    Chm::ChangeRequest.find(self.change_request_id).update_attribute(:approve_status,"REJECT")


  end

  #审批拒绝
  def approve
    self.approve_status="APPROVE"
    self.approve_at= Time.now
    self.save

    if self.class.where(:change_request_id=>self.change_request_id).count== self.class.where(:change_request_id=>self.change_request_id,:approve_status=>"APPROVE").count
      Chm::ChangeRequest.find(self.change_request_id).update_attribute(:approve_status,"APPROVE")
    end
  end


  def approve_able?(person_id)
    self.person_id.eql?(person_id)&&"APPROVING".eql?(self.approve_status)
  end

end
