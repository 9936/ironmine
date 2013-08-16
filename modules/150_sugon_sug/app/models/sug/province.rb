class Sug::Province < ActiveRecord::Base
  set_table_name :sug_provinces

  has_many :cities, :foreign_key => :province_id, :dependent => :destroy
  belongs_to :country, :foreign_key => :country_id


  #加入activerecord的通用方法和scope
  query_extend

  scope :query_by_country, lambda{|country_id|
    where(:country_id => country_id)
  }


end