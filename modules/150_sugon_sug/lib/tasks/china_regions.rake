# encoding: utf-8

require 'yaml'

namespace :china_regions do
  desc "Import regions to database from config/cities.yml"

  task :import => :environment do
    file_path = File.join(Rails.root, 'modules', '150_sugon_sug', 'config', 'cities.yml')
    data = File.open(file_path) { |file| YAML.load(file) }
    remove_china_regins && load_to_db(data)
    puts "\n China's provinces, city, region data import is end."
  end

  def remove_china_regins
    Sug::Province.delete_all && Sug::City.delete_all && Sug::District.delete_all
  end

  def load_to_db(data)
    country = Sug::Country.where(:name => "中国").first
    data.each do |province_name, province_hash|
      province = Sug::Province.create({:country_id => country.id, :name => province_name, :description => province_name })
      province_hash['cities'].each do |city_name, city_hash|
        city = Sug::City.create({:province_id => province.id, :name => city_name,:description => city_name})
        districts_hash = city_hash['districts']
        districts_hash.each do |district_name, district_hash|
          Sug::District.create({:city_id => city.id, :name => district_name, :description => district_name})
        end
      end
      print "."
    end
  end
end