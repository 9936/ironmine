class Irm::FunctionGroup < ActiveRecord::Base
  set_table_name :irm_function_groups

  #多语言关系
  attr_accessor :name,:description
  has_many :function_groups_tls,:dependent => :destroy
  acts_as_multilingual

  query_extend
  # 验证编码唯一性
  validates_presence_of :code
  validates_uniqueness_of :code, :if => Proc.new { |i| !i.code.blank? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?}

  has_many :functions

  has_many :menu_entries,:primary_key => :sub_function_group_id,:dependent => :destroy
end
