class Isp::Connection < ActiveRecord::Base

  set_table_name :isp_connections

  attr_accessor :port,:database

  belongs_to :program, :foreign_key => :program_id
  has_many :check_items, :foreign_key => :connection_id, :dependent => :destroy

  validates_presence_of :name, :program_id, :connect_type, :host

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_program, lambda{|program_id|
    where("#{table_name}.program_id=?", program_id)
  }


  #def test_sql
  #  context = {"@12_port_and_dbname" => {:port => 1521, :database => "hrms", :password => "1q2w3e"}}
  #  check_item = Isp::CheckItem.last
  #  a = check_item.connection
  #  a.execute(context, check_item)
  #end
  #
  #def test_shell
  #  context = {}
  #  check_item = Isp::CheckItem.first
  #  a = check_item.connection
  #  a.execute(context, check_item)
  #end


  def execute(context = {}, check_item)
    script = check_item.script
    hand_object_symbol(context)
    result = nil
    if script.present?
      if self.connect_type.eql?("SHELL")
        result = execute_shell(script)
      elsif self.connect_type.eql?("SQL")
        result = execute_sql(script)
      end
    end
    if self.object_symbol.present?
      {self.object_symbol => result}
    else
      result
    end
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

    def execute_sql(sql_script)
      conn = Isp::OracleAdapter.establish_connection(:adapter => "oracle_enhanced",
                                                     :host => self.host,
                                                     :port => self.port,
                                                     :database => self.database,
                                                     :username => self.username,
                                                     :password => self.password).connection

      begin
        result = conn.execute(sql_script).fetch
      rescue
        result = nil
      end
      result
    end

    def execute_shell(shell_script)
      require 'net/ssh'
      puts self.to_json
      Net::SSH.start(self.host, self.username, :password => self.password) do |ssh|
        result = ssh.exec!(shell_script)
        #ssh.open_channel do |ch|
        #  ch.exec "#{shell_script}" do |ch, success|
        #    abort "could not execute command" unless success
        #
        #    ch.on_data do |ch, data|
        #      print data
        #      ch.exec shell_script
        #    end
        #  end
        #end
        ssh.loop
        result
      end
    end
end
