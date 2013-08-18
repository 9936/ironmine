class ChinaRegion < ActiveRecord::Migration
  def change
    create_table :sug_countries, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_countries, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :sug_provinces, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "country_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_provinces, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "sug_provinces", :name, :name => "SUG_PROVINCE_N1"
    add_index "sug_provinces", :country_id, :name => "SUG_COUNTRY_ID_N1"

    create_table :sug_cities, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "province_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_cities, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "sug_cities", :name, :name => "SUG_CITY_N1"
    add_index "sug_cities", :province_id, :name => "SUG_PROVINCE_ID_N1"

    create_table :sug_districts, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "city_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_districts, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index "sug_districts", :name, :name => "SUG_DISTRICT_N1"
    add_index "sug_districts", :city_id, :name => "SUG_CITY_ID_N1"
  end
end
