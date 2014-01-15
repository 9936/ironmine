class CreateSalesOpportunity < ActiveRecord::Migration
  def change
    create_table :som_sales_opportunities, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "charge_person", :limit => 80 ,:null => false
      t.string   "name", :limit => 80,:null => false
      t.string   "content", :limit => 200
      t.string   "potential_customer", :limit => 200 ,:null => false
      t.string   "region", :limit => 80
      t.string   "address", :limit => 200
      t.string   "involved_production_info", :limit => 250
      t.string   "sales_status", :limit => 80,:null => false
      t.string   "sales_person", :limit => 80 ,:null => false
      t.string   "previous_flag",:limit => 1 ,:default=>'N'
      t.string   "possibility", :limit => 10
      t.string   "progress", :limit => 10
      t.integer   "price", :limit => 10
      t.datetime "start_at"
      t.datetime "end_at"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :som_sales_opportunities, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
