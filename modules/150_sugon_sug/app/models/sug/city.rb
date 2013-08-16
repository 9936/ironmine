class Sug::City < ActiveRecord::Base
  set_table_name :sug_cities

  has_many :districts, :foreign_key => :city_id, :dependent => :destroy
  belongs_to :province, :foreign_key => :country_id

  #加入activerecord的通用方法和scope
  query_extend

  scope :query_by_province, lambda {|province_id|
    where(:province_id => province_id)
  }

end