class Chm::ChangePlanType < ActiveRecord::Base
  set_table_name :chm_change_plan_types


  #多语言关系
  attr_accessor :name,:description
  has_many :change_plan_types_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :code,:display_sequence
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| !i.code.blank? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?},:message=>:code


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


end
