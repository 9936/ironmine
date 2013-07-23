class Isp::ParameterHistory < ActiveRecord::Base
  set_table_name :isp_parameter_histories

  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}



end