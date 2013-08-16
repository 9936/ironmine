class Sug::Address < ActiveRecord::Base
  set_table_name :sug_addresses

  #加入activerecord的通用方法和scope
  query_extend

  scope :query_by_source, lambda{|source_id, source_type|
    where(:source_id => source_id, :source_type => source_type)
  }

  scope :with_address_name, lambda{
    select("CONCAT(c.name,p.name,ci.name, d.name, #{table_name}.details) address_name").
        joins("JOIN #{Sug::Country.table_name} c ON c.id=#{table_name}.country_id").
        joins("JOIN #{Sug::Province.table_name} p ON p.id=#{table_name}.province_id").
        joins("JOIN #{Sug::City.table_name} ci ON ci.id=#{table_name}.city_id").
        joins("JOIN #{Sug::District.table_name} d ON d.id=#{table_name}.district_id")

  }
end
