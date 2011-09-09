class Icm::CloseReason < ActiveRecord::Base
  set_table_name :icm_close_reasons

  #多语言关系
  attr_accessor :name,:description
  has_many :close_reasons_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :close_code
  validates_uniqueness_of :close_code,:scope=>[:opu_id], :if => Proc.new { |i| !i.close_code.blank? }
#  validates_format_of :close_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.close_code.blank?}

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

end
