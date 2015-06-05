class AddPrimeLogTable < ActiveRecord::Migration
  def up
    create_table :icm_prime_board_logs do |t|
      t.string   "created_date",    :limit => 8
      t.string   "today_create",    :limit => 8
      t.string   "today_close",    :limit => 8
      t.string   "today_avg_create",    :limit => 8
      t.string   "today_avg_close",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :icm_prime_board_logs, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end

  def down
  end
end
