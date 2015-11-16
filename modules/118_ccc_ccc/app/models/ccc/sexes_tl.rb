class Ccc::SexesTl < ActiveRecord::Base
  set_table_name :ccc_sexes_tl

  belongs_to :sex

  validates_presence_of :name
end
