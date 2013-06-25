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

  scope :query_by_id, lambda {|id|
    where("#{table_name}.id=?", id)
  }

  scope :instance_targets, lambda{|instance_ids|
    joins("JOIN #{Emw::Interface.table_name} ei ON ei.id=#{table_name}.target_id").
        where("ei.id IN(?)", instance_ids).
        select("#{table_name}.*, ei.name, ei.description")
  }

  def execute
    result = ""
    if self.target_type.eql?("INTERFACE")
      interface = Emw::Interface.find(self.target_id)
      if self.sql_conn.present? && interface.present?
        target_sql_conn = Emw::Connection.find(self.sql_conn)
        result = target_sql_conn.execute(interface.execute)
      end
    end
    result
  end

end