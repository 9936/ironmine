class CreateSkmColumnAccessesTable < ActiveRecord::Migration
  def self.up
    create_table :skm_column_accesses, :force => true do |t|
      t.string :company_id, :limit => 22, :null => false
      t.string :column_id, :limit => 22, :null => false
      t.string :source_type, :limit => 30
      t.string :source_id, :limit => 22
      t.string "status_code", :limit => 30, :default=>"ENABLED", :null => false
      t.string "created_by", :null => false, :limit => 22
      t.string "updated_by", :null => false, :limit => 22
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end

  def self.down
    drop_table :skm_column_accesses
  end
end