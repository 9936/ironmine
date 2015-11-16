class Ccc::ConnTypesTl < ActiveRecord::Base
  set_table_name :ccc_conn_types_tl

  belongs_to :conn_type

  validates_presence_of :name
end
