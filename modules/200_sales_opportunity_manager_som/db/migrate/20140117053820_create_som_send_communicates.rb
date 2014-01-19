class CreateSomSendCommunicates < ActiveRecord::Migration
  def change
    create_table :som_send_communicates do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "person_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "communicate_enable_flag", :limit => 1 ,:default=>'Y'
      t.string   "last_interval", :limit => 30
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.timestamps
    end
    change_column :som_send_communicates, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
