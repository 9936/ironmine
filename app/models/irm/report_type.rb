class Irm::ReportType < ActiveRecord::Base
  set_table_name :irm_report_types
  attr_accessor :step,:relationship_str

  #多语言关系
  attr_accessor :name,:description
  has_many :report_types_tls,:dependent => :destroy
  acts_as_multilingual


  has_many :report_type_objects,:order=>"object_sequence"
  has_many :report_type_sections,:order=>"section_sequence"

  query_extend

  validates_presence_of :code,:business_object_id
  validates_presence_of :relationship_str ,:if=>Proc.new{|i| i.new_record?&&check_step(2)}
  validates_uniqueness_of :code,:if=>Proc.new{|i| i.code.present?}
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present?}


  scope :with_bo,lambda{|language|
    joins("JOIN #{Irm::BusinessObject.view_name} ON #{Irm::BusinessObject.view_name}.id = #{table_name}.business_object_id  AND #{Irm::BusinessObject.view_name}.language = '#{language}'").
    select("#{Irm::BusinessObject.view_name}.name business_object_name")
  }

  scope :with_category,lambda{|language|
    joins("JOIN #{Irm::ReportTypeCategory.view_name} ON #{Irm::ReportTypeCategory.view_name}.id = #{table_name}.category_id  AND #{Irm::ReportTypeCategory.view_name}.language = '#{language}'").
    select("#{Irm::ReportTypeCategory.view_name}.name category_name")
  }


  scope :select_all,lambda{
    select("#{table_name}.*")
  }

  def check_step(stp)
    self.step.nil?||self.step.to_i>=stp
  end
  # 处理关联关系
  # 1，删除原有的 对像关系、
  # 2，添加新的对像关系
  # 3，删除不必要的字段
  def process_relationship
    return false unless self.relationship_str.present?
    if self.report_type_objects
      self.report_type_objects.each do |rto|
        rto.destroy
      end
    end
    relationships = relationship_str.split(",").compact
    objects = []
    i = 0
    while i < relationships.size
      if(i==0)
        objects << [(i+1)/2,relationships[i],"primary"]
        i = i+1
      else
        objects << [(i+1)/2,relationships[i+1],relationships[i]]
        i = i+2
      end
    end
    objects.each do |o|
      self.report_type_objects.create(:object_sequence=>o[0],:business_object_id=>o[1],:relationship_type=>o[2])
    end

    if(self.report_type_sections.count>0)
      Irm::ReportTypeField.delete_not_allowed(objects.collect{|i| i[1]},self.id)
    else
      Irm::ReportTypeSection.init_fields(objects.collect{|i| i[1]},self.id)
    end
    return true
  end

  def relationship_to_s
    str = []
    self.report_type_objects.each do |rto|
      if(rto.object_sequence.to_i==0)
        str << rto.business_object_id
      else
        str << rto.relationship_type
        str << rto.business_object_id
      end
    end
    str.join(",")
  end

  def relationship_image_path
    object_index = ["A","B","C","D"]
    str = ""
    self.report_type_objects.each do |rto|
      if(rto.object_sequence.to_i==0)
        str << object_index[rto.object_sequence.to_i]
      else

        case rto.relationship_type
          when "inner"
            str << "w"
          when "outer"
            str << "wwo"
        end
        str << object_index[rto.object_sequence.to_i]
      end
    end
    str
  end
end
