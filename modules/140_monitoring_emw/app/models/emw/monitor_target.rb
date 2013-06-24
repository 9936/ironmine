class Emw::MonitorTarget < ActiveRecord::Base
  set_table_name :emw_monitor_targets

  validates_presence_of :monitor_program_id, :target_id, :target_type
  validates_presence_of :sql_conn, :if => Proc.new {|i|i.shell_conn.blank? }, :message => I18n.t(:label_emw_monitor_program_target_conn_error)
  validates_presence_of :shell_conn, :if => Proc.new {|i|i.sql_conn.blank? }, :message => I18n.t(:label_emw_monitor_program_target_conn_error)

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_program, lambda {|program_id|
    where("#{table_name}.monitor_program_id=?", program_id)
  }

  #scope :with_connection, lambda {
  #  joins("#{Emw::Connection.table_name} conn ON conn.id=#{table_name}")
  #}

  scope :instance_targets, lambda{|instance_ids|
    joins("JOIN #{Emw::Interface.table_name} ei ON ei.id=#{table_name}.target_id").
        where("ei.id IN(?)", instance_ids).
        select("#{table_name}.*, ei.name, ei.description")
  }

end