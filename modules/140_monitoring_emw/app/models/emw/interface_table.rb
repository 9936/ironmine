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

end
