# -*- coding: utf-8 -*-

class CountryData < ActiveRecord::Migration
  def change
    country = Sug::Country.new(:name => "中国", :description => "中国")
    country.save
  end
end
