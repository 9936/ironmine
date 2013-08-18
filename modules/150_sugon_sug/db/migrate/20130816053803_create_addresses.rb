class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :sug_addresses, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "source_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "source_type", :limit => 50
      t.string   "country_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "province_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "city_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "district_id", :limit => 22, :null => false, :collate => "utf8_bin"
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

    execute('CREATE OR REPLACE VIEW sug_addresses_vl AS SELECT sug_addresses.*, CONCAT(c.name,p.name,ci.name, d.name, sug_addresses.details) address_name FROM sug_addresses
            JOIN sug_countries c ON c.id=sug_addresses.country_id
            JOIN sug_provinces p ON p.id=sug_addresses.province_id
            JOIN sug_cities ci ON ci.id=sug_addresses.city_id
            JOIN sug_districts d ON d.id=sug_addresses.district_id')
  end
end
