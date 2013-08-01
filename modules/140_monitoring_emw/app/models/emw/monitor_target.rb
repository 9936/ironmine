class Emw::MonitorTarget < ActiveRecord::Base
  set_table_name :emw_monitor_targets

  validates_presence_of :monitor_program_id, :target_id, :target_type
  #validates_presence_of :sql_conn, :if => Proc.new { |i| !i.shell_conn.present? }, :message => I18n.t(:label_emw_monitor_program_target_conn_error)
  #validates_presence_of :shell_conn, :if => Proc.new { |i| !i.sql_conn.present? }, :message => I18n.t(:label_emw_monitor_program_target_conn_error)
  validates_presence_of :sql_conn, :if => Proc.new { |i| !i.shell_conn.present? }, :message => I18n.t(:label_emw_monitor_program_target_conn)
  validates_presence_of :shell_conn, :if => Proc.new { |i| !i.sql_conn.present? }, :message => I18n.t(:label_emw_monitor_program_target_conn)

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :with_program, lambda { |program_id|
    where("#{table_name}.monitor_program_id=?", program_id)
  }

  scope :query_by_id, lambda { |id|
    where("#{table_name}.id=?", id)
  }

  #scope :instance_targets, lambda{|instance_ids|
  #  joins("JOIN #{Emw::Interface.table_name} ei ON ei.id=#{table_name}.target_id").
  #      where("ei.id IN(?)", instance_ids).
  #      select("#{table_name}.*, ei.name, ei.description")
  #}

  scope :instance_targets, lambda { |instance_ids|
    joins("JOIN (select id,name,description from #{Emw::Database.table_name} Union select id,name,description from
#{Emw::Interface.table_name} Union select id,name,description from
 #{Emw::Component.table_name}) ei ON ei.id=#{table_name}.target_id").
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
    elsif self.target_type.eql?("DATABASE")
      database=Emw::Database.find(self.target_id)
      if (self.sql_conn.present?||self.shell_conn.present?) && database.present?
        if self.sql_conn.present?
          target_conn = Emw::Connection.find(self.sql_conn)
        elsif target_conn = Emw::Connection.find(self.shell_conn)
        end
        result = target_conn.execute(database.execute)
      end
    else
      component=Emw::Component.find(self.target_id)
      if self.shell_conn.present? && component.present?
        target_shell_conn = Emw::Connection.find(self.shell_conn)
        result = target_shell_conn.execute(component.execute)
      end
    end
    result
  end

end