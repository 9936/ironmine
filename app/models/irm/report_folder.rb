class Irm::ReportFolder < ActiveRecord::Base
  set_table_name :irm_report_folders

  before_save  :set_access_type

  #多语言关系
  attr_accessor :name,:description
  has_many :report_folders_tls,:dependent => :destroy
  acts_as_multilingual

  attr_accessor :member_str
  has_many :report_folder_members

  has_many :reports

  validates_presence_of :code,:access_type,:member_type
  validates_uniqueness_of :code, :if => Proc.new { |i| i.code.present? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present?}

  scope :query_by_role,lambda{|role_id|
    where("#{table_name}.member_type = ? AND EXISTS(SELECT 1 FROM #{Irm::ReportFolderMember.table_name} WHERE  #{Irm::ReportFolderMember.table_name}.report_folder_id = #{table_name}.id AND #{Irm::ReportFolderMember.table_name}.member_type=? AND  #{Irm::ReportFolderMember.table_name}.member_id = ?)","MEMBER",Irm::Role.name,role_id)
  }

  scope :query_by_roles,lambda{|role_ids|
    where("#{table_name}.member_type = ? AND EXISTS(SELECT 1 FROM #{Irm::ReportFolderMember.table_name} WHERE  #{Irm::ReportFolderMember.table_name}.report_folder_id = #{table_name}.id AND #{Irm::ReportFolderMember.table_name}.member_type=? AND  #{Irm::ReportFolderMember.table_name}.member_id in (?))","MEMBER",Irm::Role.name,role_ids)
  }

  scope :query_by_person,lambda{|person_id|
    where("#{table_name}.member_type = ? AND #{table_name}.created_by = ? OR (#{table_name}.member_type = ? AND EXISTS(SELECT 1 FROM #{Irm::ReportFolderMember.table_name} WHERE  report_folder_id = #{table_name}.id AND #{Irm::ReportFolderMember.table_name}.member_type=? AND  #{Irm::ReportFolderMember.table_name}.member_id = ?))","PRIVATE",person_id,"MEMEBER",Irm::Person.name,person_id)
  }

  scope :public,lambda{
    where(:member_type=>"PUBLIC")
  }


  #创建 更新 文件夹成员
  def create_member_from_str
    if(!self.member_type.eql?("MEMBER"))
      self.member_str = ""
    end
    return unless self.member_str
    str_members = self.member_str.split(",").delete_if{|i| !i.present?}
    exists_members = Irm::ReportFolderMember.where(:report_folder_id=>self.id)
    exists_members.each do |member|
      if exists_members.include?("#{Irm::BusinessObject.class_name_to_code(member.member_type)}##{member.member_id}")
        str_members.delete("#{Irm::BusinessObject.class_name_to_code(member.member_type)}##{member.member_id}")
      else
        member.destroy
      end

    end

    str_members.each do |member_str|
      next unless member_str.strip.present?
      member = member_str.strip.split("#")
      self.report_folder_members.build(:member_type=>Irm::BusinessObject.code_to_class_name(member[0]),:member_id=>member[1])
    end if str_members.any?
  end


  def set_access_type
    if self.member_type == "PRIVATE"
      self.access_type= "FORBID"
    end
  end
end
