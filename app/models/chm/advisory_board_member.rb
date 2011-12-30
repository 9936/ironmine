class Chm::AdvisoryBoardMember < ActiveRecord::Base
  set_table_name :chm_advisory_board_members

  validates_presence_of :advisory_board_id,:person_id

  query_extend

  scope :with_person,lambda{|language|
    joins("JOIN #{Irm::Person.table_name} people ON  people.id = #{table_name}.person_id").
    joins("LEFT OUTER JOIN #{Irm::Organization.view_name} organization  ON  organization.id = people.organization_id AND organization.language = '#{language}'").
    select("people.full_name,people.email_address,organization.name organization_name")
  }

  scope :available_for_request,lambda{|change_request_id|
    where("NOT EXISTS(SELECT 1 FROM #{Chm::ChangeApproval.table_name} WHERE #{Chm::ChangeApproval.table_name}.person_id = #{table_name}.person_id AND #{Chm::ChangeApproval.table_name}.change_request_id = ?)",change_request_id)
  }

  def self.list_all
    select_all.with_person(I18n.locale)
  end
end
