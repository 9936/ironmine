class Skm::EntryApprovalPerson < ActiveRecord::Base
  set_table_name :skm_entry_approval_people

  belongs_to :entry_header, :class_name => "Skm::EntryHeader", :foreign_key => "entry_header_id"

  scope :query_approvals_by_person, lambda{|person_id|
    select("#{table_name}.entry_header_id").
        where("#{self.table_name}.approval_flag=? AND #{table_name}.person_id=?", Irm::Constant::SYS_NO, person_id)
  }

  scope :query_approval_deny_by_entry_header_id, lambda {|entry_header_id|
    where("#{self.table_name}.approval_flag=? AND #{table_name}.entry_header_id=?", Irm::Constant::SYS_REFUSE, entry_header_id)
  }

  def self.has_unaudited_person?(entry_header_id)
    unaudited_people = self.where("#{self.table_name}.approval_flag=? AND #{self.table_name}.entry_header_id=?", Irm::Constant::SYS_NO, entry_header_id)
    if unaudited_people.any?
      true
    else
      false
    end
  end


  def self.has_other_approval_people?(entry_header_id, except_person_id)
    other_unaudited_people = self.where("#{self.table_name}.approval_flag=? AND #{self.table_name}.entry_header_id=? AND #{self.table_name}.person_id !=?",Irm::Constant::SYS_NO, entry_header_id, except_person_id)
    if other_unaudited_people.any?
      true
    else
      false
    end
  end

end
