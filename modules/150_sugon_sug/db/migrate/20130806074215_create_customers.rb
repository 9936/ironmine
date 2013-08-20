class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :sug_customers, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 200
      t.string   "parent_id", :limit => 22, :collate => "utf8_bin"
      t.string   "zip_code", :limit => 20
      t.string   "industry", :limit => 200
      t.string   "project",:limit => 200
      t.string   "profit_id", :limit => 22, :collate => "utf8_bin"
      t.string   "affect_id", :limit => 22, :collate => "utf8_bin"
      t.string   "phase_id", :limit => 22,  :collate => "utf8_bin"
      t.string   "custom_id", :limit => 22, :collate => "utf8_bin"
      t.text "note"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_customers, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index :sug_customers, :parent_id, :name => "SUG_CUSTOMER_N1"

    create_table "sug_customer_exp", :force => true do |t|
      t.string   "parent_id",        :limit => 22,                        :null => false
      t.string   "direct_parent_id", :limit => 22,                        :null => false
      t.string   "customer_id",      :limit => 22,                        :null => false
      t.string   "opu_id",           :limit => 22,                        :null => false
      t.string   "status_code",      :limit => 30, :default => "ENABLED"
      t.string   "created_by",       :limit => 22,                        :null => false
      t.string   "updated_by",       :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "sug_customer_exp", ["parent_id", "direct_parent_id", "customer_id"], :name => "SUG_CUSTOMER_EXP_U1", :unique => true

  end


end
