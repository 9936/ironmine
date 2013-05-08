class Isp::ConnectionItem < ActiveRecord::Base
  set_table_name :isp_connection_items

  validates_presence_of :connection_id, :check_item_id
  validates_uniqueness_of :connection_id, :scope => :check_item_id

  belongs_to :conn, :class_name => "Isp::Connection", :foreign_key => :connection_id

end