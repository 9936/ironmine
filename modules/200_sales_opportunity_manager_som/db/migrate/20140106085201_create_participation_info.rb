class CreateParticipationInfo < ActiveRecord::Migration
  def change
    create_table :som_participation_infos do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name"
      t.string   "role"
      t.string   "client_flag",:limit=>1,:default=>"N"
      t.string   "communicate_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.timestamps
    end
    change_column :som_participation_infos, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
