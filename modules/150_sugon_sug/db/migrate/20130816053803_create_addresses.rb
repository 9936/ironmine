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
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_addresses, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index :sug_addresses, [:source_id, :source_type], :name => "SUG_ADDRESSES_N1"
  end
end
