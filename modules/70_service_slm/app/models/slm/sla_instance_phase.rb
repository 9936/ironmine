class Slm::SlaInstancePhase < ActiveRecord::Base
  set_table_name :slm_sla_instance_phases

  belongs_to :sla_instance


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end