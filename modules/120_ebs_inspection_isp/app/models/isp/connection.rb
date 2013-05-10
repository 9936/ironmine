class Isp::Connection < ActiveRecord::Base

  set_table_name :isp_connections

  attr_accessor :port,:database

  belongs_to :program, :foreign_key => :program_id
  has_many :connection_items, :foreign_key => :connection_id, :dependent => :destroy
  has_many :check_items , :through => :connection_items
  has_many :connection_items, :foreign_key => :connection_id, :dependent => :destroy

  validates_presence_of :name, :program_id, :connect_type, :host

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_program, lambda{|program_id|
    where("#{table_name}.program_id=?", program_id)
  }




  def execute(context = {})
    result = {}
    #将连接中的SHELL和SQL分开
    shell_check_items = []
    sql_check_items = []

    self.check_items.each do |check_item|
      if self.connect_type.eql?("SHELL")
        shell_check_items << check_item
      elsif self.connect_type.eql?("SQL")
        sql_check_items << check_item
      end
    end

    if shell_check_items.any?
      ssh_conn = get_ssh_connection
    else
      ssh_conn = nil
    end

    if sql_check_items.any?
      sql_conn = get_sql_connection
    else
      sql_conn = nil
    end

    self.check_items.each do |check_item|
      context[self.object_symbol].merge!(check_item.execute(context[self.object_symbol]))

      script = check_item.script
      hand_object_symbol(context)

      if script.present?
        if self.connect_type.eql?("SHELL")
          if ssh_conn.is_a?(Net::SSH::Connection::Session)
            result[check_item.object_symbol] = execute_shell(ssh_conn, script)
          else
            result[check_item.object_symbol] = ssh_conn
          end

        elsif self.connect_type.eql?("SQL")
          result[check_item.object_symbol] = execute_sql(sql_conn, script)
        end
      end
    end

    ssh_conn.close if ssh_conn.is_a?(Net::SSH::Connection::Session)
    ssh_conn = nil

    result
  end

  private
    def hand_object_symbol(context)
      if context && context[self.object_symbol]
        self.username = context[self.object_symbol][:username] if context[self.object_symbol][:username].present?
        self.password = context[self.object_symbol][:password] if context[self.object_symbol][:password].present?
        self.port = context[self.object_symbol][:port] if context[self.object_symbol][:port].present?
        self.database = context[self.object_symbol][:database] if context[self.object_symbol][:database].present?
      end

    end


    def get_sql_connection
      @conn ||= Isp::OracleAdapter.establish_connection(:adapter => "oracle_enhanced",
                                                        :host => self.host,
                                                        :port => self.port,
                                                        :database => self.database,
                                                        :username => self.username,
                                                        :password => self.password).connection
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
        result = conn.execute(sql_script).fetch
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
