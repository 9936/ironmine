class CreateOrderBases < ActiveRecord::Migration
  def change
    create_table "win_order_bases", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "cus_code",          :limit => 60, :null => false
      t.string   "cus_replace_code",          :limit => 60
      t.string   "yh_number",  :limit => 60
      t.string   "yh_replace_number",  :limit => 60
      t.integer  "box_per_count", :limit => 8, :default => 0
      t.integer  "basic_count", :limit => 8, :default => 0
      t.string   "put_type",   :limit => 20
      t.integer  "layers_count", :limit => 8
      t.string   "material", :limit => 60
      t.string   "art_type", :limit => 60
      t.string   "bp", :limit => 30
      t.string   "basic_price", :limit => 30
      t.string   "basic_bolt_price", :limit => 30
      t.string   "basic_bp_price", :limit => 30
      t.string   "basic_bolt_bp_price", :limit => 30
      t.string   "bp_per_price", :limit => 30
      t.string   "info_flag", :limit => 1
      t.string   "kba_code", :limit => 30
      t.string   "kba_type", :limit => 30
      t.string   "type_code", :limit => 30
      t.string   "package", :limit => 30
      t.string   "dolt_type", :limit => 30
      t.integer   "dolt_number", :limit => 8, :default => 0
      t.string   "dolt_per_price", :limit => 30
      t.string   "dolt_yh_per_price", :limit => 30
      t.string   "dolt_info", :limit => 100
      t.string   "paper_flag", :limit => 10
      t.string   "gan_flag", :limit => 10
      t.string   "paper_judge_flag", :limit => 10
      t.string   "order_suffix", :limit => 60
      t.string   "priority", :limit => 30
      t.string   "priority_change", :limit => 30
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :win_order_bases, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "win_order_bases", ["customer_code", "yh_number"], :name => "WIN_ORDER_BASES_N1"
  end
end
