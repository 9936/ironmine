class CreateContacts < ActiveRecord::Migration
  def change
    create_table :sug_contacts, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "first_name", :limit => 30, :null => false
      t.string   "last_name", :limit => 30
      t.string   "sex", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "email_address", :limit => 150
      t.string   "home_phone", :limit => 30
      t.string   "mobile_phone", :limit => 30
      t.string   "zip_code", :limit => 10
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_contacts, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :sug_customer_contacts, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "customer_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "contact_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

  end
end
