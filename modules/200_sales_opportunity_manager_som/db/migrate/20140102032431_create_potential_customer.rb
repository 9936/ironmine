class CreatePotentialCustomer < ActiveRecord::Migration
  def change
    create_table :som_potential_customers, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "short_name", :limit => 50
      t.string   "full_name", :limit => 80 ,:null => false
      t.string   "industry", :limit => 100
      t.string   "website", :limit => 100
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :som_potential_customers, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
