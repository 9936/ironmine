class CreateIrmReadedBulletins < ActiveRecord::Migration
  def change
    create_table :irm_readed_bulletins, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "person_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "bulletin_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps
    end
    change_column :irm_readed_bulletins, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
