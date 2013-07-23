class Isp::ProgramHistory < ActiveRecord::Base
  set_table_name :isp_program_histories

  validates_presence_of :program_id
  has_many :conn_histories, :foreign_key => :program_history_id, :dependent => :destroy

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  scope :with_program, lambda {|program_id|
    where("#{table_name}.program_id=?", program_id)
  }
end
