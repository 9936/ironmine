class Ccc::PriceTypesTl < ActiveRecord::Base
  set_table_name :ccc_price_types_tl

  belongs_to :price_type

  validates_presence_of :name
end
