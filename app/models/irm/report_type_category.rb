class Irm::ReportTypeCategory < ActiveRecord::Base
  set_table_name :irm_report_type_categories


  #多语言关系
  attr_accessor :name,:description
  has_many :report_type_categories_tls,:dependent => :destroy
  acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_presence_of :code
  validates_uniqueness_of :code,:scope=>[:opu_id],:if=>Proc.new{|i| i.code.present?}
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present?},:message=>:code

end
