class Irm::SystemParameter < ActiveRecord::Base
  set_table_name :irm_system_parameters


  #多语言关系
  attr_accessor :name, :description
  has_many :system_parameters_tls, :dependent => :destroy
  has_many :system_parameter_values,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :parameter_code
  validates_uniqueness_of :parameter_code,:scope=>[:opu_id], :if => Proc.new { |i| !i.parameter_code.blank? }
  validates_format_of :parameter_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.parameter_code.blank?},:message=>:code

  #加入activerecord的通用方法和scope
  query_extend

  #定义缓存全局设置的实例变量

  def self.global_setting
    if @global_setting
       return @global_setting
    else
       return @global_setting=query_by_type("GLOBAL_SETTING")
    end

  end


  #根据Feature #1176  将parameter_value从parameter表中分离出来时，为避免对上层代码的大量重构，故添加这两个img方法，使img成为parameter表个伪字段,value字段 同上
  def img
    paramvalue=Irm::SystemParameterValue.where(:system_parameter_id=>"#{self.id}")
    paramfirst=paramvalue.first
    if paramfirst
      return paramfirst.img
    else
      return  paramfirst.create.img
    end

  end

  def img=(pic)

     paramvalue=Irm::SystemParameterValue.where(:system_parameter_id=>"#{self.id}")
     paramfirst=paramvalue.first
     if paramfirst
       paramfirst.img=pic
       paramfirst.save
     else
        paramvalue.create(:img=>pic)
     end
  end
  def value
    paramvalue=Irm::SystemParameterValue.where(:system_parameter_id=>"#{self.id}")
    paramsfirst=paramvalue.first
    if paramsfirst
       return  paramsfirst.value
    else
       return  paramvalue.create.value
    end
  end
  def value=(v)
    paramvalue=Irm::SystemParameterValue.where(:system_parameter_id=>"#{self.id}")
    paramsfirst=paramvalue.first
    if paramsfirst
        paramsfirst.value=v
        paramsfirst.save
    else
        paramvalue.create(:value=>v)
    end
  end


  scope :select_all, lambda{
    with_values.select("#{table_name}.*,spt.name name, spt.description description").
        joins(",#{Irm::SystemParametersTl.table_name} spt").
        where("#{table_name}.id = spt.system_parameter_id and spt.language = ?",I18n.locale)
  }

  scope :with_values, lambda{
    joins("LEFT OUTER JOIN irm_system_parameter_values ON irm_system_parameter_values.system_parameter_id = #{table_name}.id and irm_system_parameter_values.opu_id ='#{Irm::OperationUnit.current.id}'").
        select("irm_system_parameter_values.value,irm_system_parameter_values.img_updated_at,"+
                  "irm_system_parameter_values.img_file_size,irm_system_parameter_values.img_content_type,"+
                  "irm_system_parameter_values.img_file_name")

  }

  scope :query_by_code, lambda{|parameter_code|
    select_all.where("#{table_name}.parameter_code = ?", parameter_code)
  }

  scope :query_by_type, lambda{|content_type|
    select_all.where("#{table_name}.content_type = ?", content_type)
  }

  def self.get_value_by_code(parameter_code)
    ret = query_by_code(parameter_code)
    if ret.any?
      return ret.first.value
    else
      return ""
    end
  end
end