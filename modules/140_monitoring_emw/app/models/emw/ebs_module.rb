class Emw::EbsModule < ActiveRecord::Base
  set_table_name :emw_ebs_modules


  has_many :interfaces, :foreign_key => :ebs_module_id, :dependent => :destroy

  validates_presence_of :name, :module_code



  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


end
