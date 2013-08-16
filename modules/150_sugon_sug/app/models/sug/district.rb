class Sug::District < ActiveRecord::Base
  set_table_name :sug_districts


  belongs_to :city, :foreign_key => :province_id


  #加入activerecord的通用方法和scope
  query_extend


  scope :query_by_city, lambda {|city_id|
    where(:city_id => city_id)
  }


end