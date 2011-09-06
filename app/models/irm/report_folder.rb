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
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| i.code.present? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present?}

  scope :private,lambda{|person_id|
    where("#{table_name}.created_by = ?",person_id)
  }

  scope :public,lambda{
    where(:member_type=>"PUBLIC")
  }

  scope :accessible,lambda{|person_id|
    joins("JOIN #{Irm::ReportFolderMember.table_name} ON #{Irm::ReportFolderMember.table_name}.report_folder_id = #{table_name}.id").
        where(:member_type=>"MEMBER").
            where("EXISTS(SELECT 1 FROM #{Irm::Person.relation_view_name} WHERE #{Irm::Person.relation_view_name}.source_id = #{Irm::ReportFolderMember.table_name}.member_id AND #{Irm::Person.relation_view_name}.source_type = #{Irm::ReportFolderMember.table_name}.member_type AND  #{Irm::Person.relation_view_name}.person_id = ?)",person_id)
  }

  #创建 更新 文件夹成员
  def create_member_from_str
    if(!self.member_type.eql?("MEMBER"))
      self.member_str = ""
    end
    return unless self.member_str
    str_values = self.member_str.split(",").delete_if{|i| !i.present?}
    exists_values = Irm::ReportFolderMember.where(:report_folder_id=>self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.member_type}##{value.member_id}")
        str_values.delete("#{value.member_type}##{value.member_id}")
      else
        value.destroy
      end

    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      self.report_folder_members.create(:member_type=>value[0],:member_id=>value[1])
    end
  end



  def get_member_str
    return @get_member_str if @get_member_str
    @get_member_str||=member_str
    @get_member_str||= Irm::ReportFolderMember.where(:report_folder_id=>self.id).collect{|value| "#{value.member_type}##{value.member_id}"}.join(",")
  end


  def set_access_type
    if self.member_type == "PRIVATE"
      self.access_type= "FORBID"
    end
  end


end
