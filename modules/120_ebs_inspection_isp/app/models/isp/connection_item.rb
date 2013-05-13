class Isp::ConnectionItem < ActiveRecord::Base
  set_table_name :isp_connection_items

  validates_presence_of :connection_id, :check_item_id
  validates_uniqueness_of :connection_id, :scope => :check_item_id

  belongs_to :conn, :class_name => "Isp::Connection", :foreign_key => :connection_id
  belongs_to :check_item, :foreign_key => :check_item_id


  scope :query_by_conn_item, lambda{|conn_id, item_id|
    where("#{table_name}.connection_id=? AND check_item_id=?", conn_id, item_id)
  }


end