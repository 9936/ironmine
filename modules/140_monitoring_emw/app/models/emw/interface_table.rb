class Emw::InterfaceTable < ActiveRecord::Base
  set_table_name :emw_interface_tables

  attr_accessor :host, :username, :password, :error_message_column,:import_flag

  belongs_to :interface, :foreign_key => :interface_id
  has_many :interface_columns, :foreign_key => :interface_table_id, :dependent => :destroy
  has_one :errors_table, :class_name => "Emw::ErrorTable", :foreign_key => :interface_table_id

  validates_presence_of :table_name, :interface_id
  validates_presence_of :name,:if => Proc.new{|i| i.import_flag != 'Y' }

  validates_presence_of :host, :username, :password, :error_message_column, :if => Proc.new { |i| i.import_flag == 'Y' }

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  def get_columns
    conn = Isp::OracleAdapter.establish_connection(:adapter => "oracle_enhanced",
                                                   :database => "(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = vs011.hand-china.com)(PORT = 1522))) (CONNECT_DATA = (SERVICE_NAME = VIS01)))",
                                                   :username => self.username,
                                                   :password => self.password).connection

    begin
      result = conn.select_rows("select column_name, data_type, data_length from user_tab_columns where Table_Name='ADS_OPM_SUPPLY_INTERFACE'")
      #comments = conn.select_rows("select column_name, comments FROM USER_COL_COMMENTS WHERE  TABLE_NAME = 'ADS_OPM_SUPPLY_INTERFACE'")
    rescue
      result = nil
    end
    result
  end



end
