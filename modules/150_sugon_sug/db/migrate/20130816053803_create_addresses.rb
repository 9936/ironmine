# -*- coding: utf-8 -*-

class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :sug_addresses, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "source_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "source_type", :limit => 50
      t.string   "country_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "province_id", :limit => 22,  :collate => "utf8_bin"
      t.string   "city_id", :limit => 22,  :collate => "utf8_bin"
      t.string   "district_id", :limit => 22, :collate => "utf8_bin"
      t.string   "details"
      t.string   "default_flag", :limit => 1, :default => 'Y'
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_addresses, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index :sug_addresses, [:source_id, :source_type], :name => "SUG_ADDRESSES_N1"

    execute("CREATE OR REPLACE VIEW sug_addresses_vl AS SELECT CONCAT(c.name,
            CASE WHEN p.name IS NULL THEN '' ELSE p.name END,
            CASE WHEN (ci.name IS NULL OR ci.name IN('北京市','上海市','重庆市','天津市')) THEN '' ELSE ci.name END,
            CASE WHEN d.name IS NULL THEN '' ELSE d.name END,sug_addresses.details )address_name, sug_addresses.* FROM sug_addresses
            LEFT JOIN sug_countries c ON c.id=sug_addresses.country_id
            LEFT JOIN sug_provinces p ON p.id=sug_addresses.province_id
            LEFT JOIN sug_cities ci ON ci.id=sug_addresses.city_id
            LEFT JOIN sug_districts d ON d.id=sug_addresses.district_id")
  end
end
