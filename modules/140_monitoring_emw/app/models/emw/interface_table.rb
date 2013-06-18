class Emw::InterfaceTable < ActiveRecord::Base
  set_table_name :emw_interface_tables

  attr_accessor :database, :username, :password, :step,:import_flag

  belongs_to :interface, :foreign_key => :interface_id
  has_many :interface_columns, :foreign_key => :interface_table_id, :dependent => :destroy
  has_one :errors_table, :class_name => "Emw::ErrorTable", :foreign_key => :interface_table_id

  validates_presence_of :table_name, :interface_id
  validates_presence_of :name,:if => Proc.new{|i| i.import_flag != 'Y' || (i.import_flag == 'Y' && i.step == 4) }

  validates_presence_of :database, :username, :password, :if => Proc.new { |i| i.import_flag == 'Y' }

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_by_interface, lambda {|interface_id|
    where("#{table_name}.interface_id=?", interface_id)
  }


  def get_columns
    #self.table_name = "ADS_OPM_SUPPLY_INTERFACE"
    #self.database = "(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = vs011.hand-china.com)(PORT = 1522))) (CONNECT_DATA = (SERVICE_NAME = VIS01)))"
    begin
      conn = Isp::OracleAdapter.establish_connection(:adapter => "oracle_enhanced",
                                                    :database => self.database,
                                                    :username => self.username,
                                                    :password => self.password).connection
    rescue OCIError => e
      raise e.message
    end

    begin
      result = conn.select_rows("select t.column_name, t.data_type, t.data_length, c.comments from user_tab_columns t left join user_col_comments c on t.column_name=c.column_name and t.table_name=c.table_name where t.table_name='#{self.table_name}'")
    rescue
      result = nil
    end
    result
  end



end
