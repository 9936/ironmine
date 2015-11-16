class Ccc::CustomerStatusesTl < ActiveRecord::Base
  set_table_name :ccc_customer_statuses_tl

  belongs_to :customer_status

  validates_presence_of :name
end
