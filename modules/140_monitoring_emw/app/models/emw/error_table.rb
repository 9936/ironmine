class Emw::ErrorTable < ActiveRecord::Base
  set_table_name :emw_error_tables

  belongs_to :interface_table, :foreign_key => :interface_table_id

  validates_presence_of :name, :interface_table_id, :interface_column, :error_code_column, :error_message_column

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  after_save :set_interface_table

  private
    def set_interface_table
      self.interface_table.error_table = self.name
      self.interface_table.save
    end
end