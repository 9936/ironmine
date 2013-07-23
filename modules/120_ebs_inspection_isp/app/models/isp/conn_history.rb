class Isp::ConnHistory < ActiveRecord::Base
  set_table_name :isp_conn_histories

  validates_presence_of :program_history_id, :host, :username, :password

  belongs_to :program_history, :foreign_key => :program_history_id
  has_many :parameter_histories, :foreign_key => :conn_history_id, :dependent => :destroy

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_program_history, lambda{|program_history_id|
    where("#{table_name}.program_history_id=?", program_history_id)
  }
end