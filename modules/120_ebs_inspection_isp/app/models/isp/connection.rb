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
    self.check_items.each do |check_item|
      context[self.object_symbol].merge!(check_item.execute(context[self.object_symbol]))

      script = check_item.script
      hand_object_symbol(context)

      if script.present?
        if self.connect_type.eql?("SHELL")
          result[check_item.object_symbol] = execute_shell(script)
        elsif self.connect_type.eql?("SQL")
          result[check_item.object_symbol] = execute_sql(script)
        end
      end
    end
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
      require 'net/sftp'

      tmp_script_file = "#{(Time.now.to_f * 10E7).to_i}.sh"

      file = File.new("#{Rails.root}/tmp/#{tmp_script_file}", "w")
      file.puts "BASH=`which bash`"

      script_lines = shell_script.split("\r\n")
      script_lines.each do |script_line|
        file.puts script_line
      end

      file.close



      #cmd = "touch #{tmp_script_file}"
      #cmd << " && echo '#!/bin/sh' >> #{tmp_script_file}"
      #cmd << " && echo '#{shell_script}' >> #{tmp_script_file}"
      #cmd << " && chmod +x #{tmp_script_file}"
      #cmd << " && ./#{tmp_script_file}"

      begin
        Net::SSH.start(self.host, self.username, :password => self.password) do |ssh|
          ssh.sftp.upload!("#{Rails.root}/tmp/#{tmp_script_file}", "#{tmp_script_file}")
          result = ssh.exec!("chmod +x #{tmp_script_file} && $BASH ./#{tmp_script_file}")
          ssh.exec!("rm -f #{tmp_script_file}")
          `rm -f #{Rails.root}/tmp/#{tmp_script_file}`
          result
        end
      rescue Net::SSH::AuthenticationFailed => ea
        `rm -f #{Rails.root}/tmp/#{tmp_script_file}`
        I18n.t(:label_isp_connection_exception, :host => self.host)
      rescue Net::SSH::Exception => e
        `rm -f #{Rails.root}/tmp/#{tmp_script_file}`
        e.message
      end


    end
end
