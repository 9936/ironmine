# -*- coding: utf-8 -*-

class Sug::Address < ActiveRecord::Base
  set_table_name :sug_addresses

  #加入activerecord的通用方法和scope
  query_extend

  scope :query_by_source, lambda{|source_id, source_type|
    where(:source_id => source_id, :source_type => source_type)
  }

  scope :with_address_name, lambda{
    select("CONCAT(c.name,
            CASE WHEN p.name IS NULL THEN '' ELSE p.name END,
            CASE WHEN (ci.name IS NULL OR ci.name IN('北京市','上海市','重庆市','天津市')) THEN '' ELSE ci.name END,
            CASE WHEN d.name IS NULL THEN '' ELSE d.name END, #{table_name}.details) address_name").
        joins("LEFT JOIN #{Sug::Country.table_name} c ON c.id=#{table_name}.country_id").
        joins("LEFT JOIN #{Sug::Province.table_name} p ON p.id=#{table_name}.province_id").
        joins("LEFT JOIN #{Sug::City.table_name} ci ON ci.id=#{table_name}.city_id").
        joins("LEFT JOIN #{Sug::District.table_name} d ON d.id=#{table_name}.district_id")

  }

end
