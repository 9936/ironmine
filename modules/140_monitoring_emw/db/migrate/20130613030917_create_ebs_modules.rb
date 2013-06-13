class CreateEbsModules < ActiveRecord::Migration
  def change
    create_table :emw_ebs_modules, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "module_code",  :limit => 30, :null => false
      t.string   "name", :limit => 150
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :emw_ebs_modules, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
