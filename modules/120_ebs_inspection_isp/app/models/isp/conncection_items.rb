class Isp::ConnectionItems < ActiveRecord::Base
  set_table_name :isp_connection_items

  belongs_to :conn, :class_name => "Isp::Connection", :foreign_key => :connection_id

end