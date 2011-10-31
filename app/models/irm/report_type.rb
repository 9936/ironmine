class Irm::ReportType < ActiveRecord::Base
  set_table_name :irm_report_types
  attr_accessor :step,:relationship_str

  #多语言关系
  attr_accessor :name,:description
  has_many :report_types_tls,:dependent => :destroy
  acts_as_multilingual


  has_many :report_type_objects,:order=>"object_sequence"
  has_many :report_type_sections,:order=>"section_sequence"

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_presence_of :code,:business_object_id
  validates_presence_of :relationship_str ,:if=>Proc.new{|i| i.new_record?&&check_step(2)}
  validates_uniqueness_of :code,:scope=>[:opu_id],:if=>Proc.new{|i| i.code.present?}
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present?},:message=>:code


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

  def table_name_hash
    return @table_name_hash if @table_name_hash
    table_names = ["a","b","c","d"]
    @table_name_hash = {}
    report_type_objects.each do |rto|
      @table_name_hash.merge!( {rto.business_object_id=>table_names[rto.object_sequence.to_i]})
    end
    @table_name_hash
  end

  #生成查询语句
  def generate_scope
    query_str = {:from=>[],:joins=>[]}
    table_names = ["a","b","c","d"]
    report_type_objects.each_with_index do |rto,index|
      bo = rto.business_object
      if(index == 0)
        query_str[:from]<< "(#{eval(bo.generate_query(true)).to_sql}) #{table_names[index]}"
      else
        relation_attribute = Irm::ObjectAttribute.where(:relation_bo_id=>report_type_objects[index-1].business_object.business_object_id,
                                                        :business_object_id=>bo.id,:category=>"MASTER_DETAIL_RELATION").first

        clause_attribute = Irm::ObjectAttribute.where(:id=>relation_attribute.relation_object_attribute_id).first
        join_str = ""
        if(relation_attribute&&clause_attribute)
          case rto.relationship_type
            when "inner"
              join_str << "JOIN "
            when "outer"
              join_str << "LEFT OUTER JOIN "
          end
          join_str << "(#{eval(bo.generate_query(true)).to_sql}) #{table_names[index]} ON #{table_names[index-1]}.#{clause_attribute.attribute_name}=#{table_names[index]}.#{relation_attribute.attribute_name}"
          query_str[:joins] << join_str
        else
          break
        end

      end
    end
    scope_str = %Q(#{self.class.name}.unscoped.from("#{query_str[:from].first}"))
    query_str[:joins].each do |j|
      scope_str << %Q(.joins("#{j}"))
    end
    scope_str
  end
end
