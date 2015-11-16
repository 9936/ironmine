class Ccc::IndustriesTl < ActiveRecord::Base
  set_table_name :ccc_industries_tl

  belongs_to :industry

  validates_presence_of :name

end
