class Irm::SystemParameter < ActiveRecord::Base
  set_table_name :irm_system_parameters
  has_attached_file :img
  validates_attachment_size :img, :less_than => Irm::SystemParametersManager.upload_file_limit.kilobytes

  #多语言关系
  attr_accessor :name, :description
  has_many :system_parameters_tls, :dependent => :destroy
  acts_as_multilingual

  validates_presence_of :parameter_code
  validates_uniqueness_of :parameter_code,:scope=>[:opu_id], :if => Proc.new { |i| !i.parameter_code.blank? }
  validates_format_of :parameter_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.parameter_code.blank?},:message=>:code

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :select_all, lambda{
    select("#{table_name}.*, spt.name name, spt.description description").
        joins(",#{Irm::SystemParametersTl.table_name} spt").
        where("#{table_name}.id = spt.system_parameter_id").
        where("spt.language = ?", I18n.locale)
  }

  scope :query_by_code, lambda{|parameter_code|
    where("#{table_name}.parameter_code = ?", parameter_code)
  }

  scope :query_by_type, lambda{|content_type|
    where("#{table_name}.content_type = ?", content_type)
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