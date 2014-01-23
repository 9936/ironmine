class CreateSomCommunicateInfos < ActiveRecord::Migration
  def change
    create_table :som_communicate_infos do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.date "communicate_date"
      t.string "content"
      t.string "sales_status" , :limit => 10
      t.string   "current_possibility", :limit => 10
      t.string   "current_progress", :limit => 10
      t.string   "sales_opportunity_id", :limit => 22, :collate => "utf8_bin"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.timestamps
    end
    change_column :som_communicate_infos, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end