class Isp::CheckItem < ActiveRecord::Base
  set_table_name :isp_check_items


  has_many :alert_filters, :foreign_key => :check_item_id, :dependent => :destroy

  #belongs_to :program, :foreign_key => :program_id
  belongs_to :conn, :class_name => "Isp::Connection", :foreign_key => :connection_id

  validates_presence_of :name, :object_symbol, :script
  #validates_uniqueness_of :connection_id, :scope => :program_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  #scope :with_program, lambda{|program_id|
  #  where("#{table_name}.program_id=?", program_id)
  #}
  #
  #scope :with_connection, lambda {
  #  joins("JOIN #{Isp::Connection.table_name} ispc ON #{table_name}.connection_id=ispc.id").
  #      select("#{table_name}.*, ispc.name connection_name")
  #}


  def execute(context)
    self.conn.execute(context,self)
  end
end
