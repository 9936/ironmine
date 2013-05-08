class Isp::CheckItem < ActiveRecord::Base
  set_table_name :isp_check_items


  has_many :alert_filters, :foreign_key => :check_item_id, :dependent => :destroy
  has_many :check_parameters, :foreign_key => :check_item_id, :dependent => :destroy
  has_many :connection_items, :foreign_key => :check_item_id, :dependent => :destroy

  belongs_to :conn, :class_name => "Isp::Connection", :foreign_key => :connection_id

  validates_presence_of :name, :object_symbol, :script

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_available_items, lambda{|connection_id|
    where("NOT EXISTS(SELECT 1 FROM #{Isp::ConnectionItem.table_name} isp_ci WHERE (isp_ci.check_item_id=#{table_name}.id AND isp_ci.connection_id = '#{connection_id}'))")
  }

  scope :query_by_connection, lambda{|connection_id|
    joins("JOIN #{Isp::ConnectionItem.table_name} isp_ci ON #{table_name}.id = isp_ci.check_item_id").
        where("isp_ci.connection_id=?", connection_id).
        select("#{table_name}.*, isp_ci.id connection_item_id")
  }

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
