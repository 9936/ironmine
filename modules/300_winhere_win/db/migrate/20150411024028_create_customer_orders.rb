class CreateCustomerOrders < ActiveRecord::Migration
  def change
    create_table "win_customer_orders", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string    "batch_number", :limit => 20, :null => false
      t.string   "vendor_number",          :limit => 60, :null => false
      t.string   "purchase_order",          :limit => 60
      t.string   "po_line_number",          :limit => 60
      t.string   "part_number",          :limit => 60
      t.string   "vendor_part_number",          :limit => 60
      t.integer   "quantity",          :limit => 8, :default => 0
      t.datetime  "deliver_date"
      t.datetime  "reschedule_due_date"
      t.datetime  "po_created_date"
      t.float     "purchase_price"
      t.float     "extended_cost"
      t.string    "success_flag", :limit => 1, :default => "Y"
      t.text      "error_message"
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :win_customer_orders, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "win_customer_orders", ["batch_number"], :name => "WIN_CUSTOMER_ORDERS_N1"
  end
end
