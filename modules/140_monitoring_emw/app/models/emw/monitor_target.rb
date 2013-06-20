class Emw::MonitorTarget < ActiveRecord::Base
  set_table_name :emw_monitor_targets

  validates_presence_of :monitor_program_id, :target_id, :target_type

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_program, lambda {|program_id|
    where("#{table_name}.monitor_program_id=?", program_id)
  }

  scope :instance_targets, lambda{|instance_ids|
    joins("JOIN #{Emw::Interface.table_name} ei ON ei.id=#{table_name}.target_id").
        where("ei.id IN(?)", instance_ids).
        select("#{table_name}.*, ei.name, ei.description")
  }

end