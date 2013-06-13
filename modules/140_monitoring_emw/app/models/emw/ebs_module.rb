class Emw::EbsModule < ActiveRecord::Base
  set_table_name :emw_ebs_modules

  #多语言关系
  attr_accessor :name,:description
  has_many :ebs_modules_tls, :dependent => :destroy

  validates_presence_of :module_code

  acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


end
