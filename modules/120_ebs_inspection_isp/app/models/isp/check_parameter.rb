class Isp::CheckParameter < ActiveRecord::Base
  set_table_name :isp_check_parameters

  belongs_to :program, :foreign_key => :program_id
  validates_presence_of :name, :program_id, :param_type, :data_type, :object_symbol, :value

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_program, lambda{|program_id|
    where("#{table_name}.program_id=?", program_id)
  }
end
