class Emw::Connection < ActiveRecord::Base

  set_table_name :emw_connections

  attr_accessor :port, :database

  validates_presence_of :name, :connect_type, :host

  #validates_presence_of :database, :if => :sql_conn?

  #before_save :set_host
  #after_find :hand_host



  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :query_by_ids, lambda {|ids|
    where("#{table_name}.id IN(?)", ids)
  }

  scope :shell_conns, lambda {
    where("#{table_name}.connect_type =?", "SHELL")
  }

  scope :sql_conns, lambda {
    where("#{table_name}.connect_type =?", "SQL")
  }

  def execute(scripts = [])
    result = []
    if self.connect_type.eql?("SHELL")
      ssh_conn = get_ssh_connection
    elsif self.connect_type.eql?("SQL")
      sql_conn = get_sql_connection
    end
    scripts.each do |script|
      if script.present?
        if self.connect_type.eql?("SHELL")
          if ssh_conn.is_a?(Net::SSH::Connection::Session)
            result << {:script => script, :result => execute_shell(ssh_conn, script) }
          else
            result<< {:error_info => ssh_conn}
          end
        elsif self.connect_type.eql?("SQL")
          if sql_conn.is_a?(ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter)
            result << {:script => script, :result => execute_sql(sql_conn, script).first }
          else
            result << {:error_info => sql_conn}
          end
        end
      end
    end
    ssh_conn.close if ssh_conn.is_a?(Net::SSH::Connection::Session)
    result
  end


  private

    def get_sql_connection
      #self.table_name = "ADS_OPM_SUPPLY_INTERFACE"
      #self.database = "(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = vs011.hand-china.com)(PORT = 1522))) (CONNECT_DATA = (SERVICE_NAME = VIS01)))"
      self.database = self.host
      begin
        @conn ||= Isp::OracleAdapter.establish_connection(:adapter => "oracle_enhanced",
                                                          #:host => self.host,
                                                          #:port => self.port,
                                                          :database => self.database,
                                                          :username => self.username,
                                                          :password => self.password).connection
      rescue Exception => e
        "#{self.database}\n" << e.message
      end
    end

    def get_ssh_connection
      require 'net/ssh'
      require 'net/sftp'

      begin
        @ssh ||= Net::SSH.start(self.host, self.username, :password => self.password)
      rescue Net::SSH::AuthenticationFailed => ea
        I18n.t(:label_isp_connection_exception, :host => self.host)
      rescue Net::SSH::Exception => e
        e.message
      rescue Errno::ECONNREFUSED => ee
        "#{ee.message}\n" << I18n.t(:label_isp_connection_econnrefused, :host => self.host)
      end
    end

    def execute_sql(conn, sql_script)
      begin
        result = conn.select_values(sql_script)
      rescue
        result = nil
      end
      result
    end


    def execute_shell(ssh, shell_script)
      tmp_script_file = "#{(Time.now.to_f * 10E7).to_i}.sh"

      file = File.new("#{Rails.root}/tmp/#{tmp_script_file}", "w")
      file.puts "BASH=`which bash`"

      script_lines = shell_script.split("\r\n")
      script_lines.each do |script_line|
        file.puts script_line
      end

      file.close

      ssh.sftp.upload!("#{Rails.root}/tmp/#{tmp_script_file}", "#{tmp_script_file}")
      result = ssh.exec!("chmod +x #{tmp_script_file} && $BASH ./#{tmp_script_file}")
      ssh.exec!("rm -f #{tmp_script_file}")
      `rm -f #{Rails.root}/tmp/#{tmp_script_file}`
      result
    end
end
