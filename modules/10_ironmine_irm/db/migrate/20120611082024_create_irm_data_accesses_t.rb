class CreateIrmDataAccessesT < ActiveRecord::Migration
  def up
    create_table :irm_data_accesses_t, :id => false do |t|
      t.string   "opu_id",                  :limit => 22 , :collate=>"utf8_bin"
      t.string   "business_object_id",      :limit => 22 , :collate=>"utf8_bin", :null=>false
      t.string   "bo_model_name",           :limit => 150, :null=>false
      t.string   "source_person_id",        :limit => 22 , :collate=>"utf8_bin", :null=>false
      t.string   "target_person_id",        :limit => 22 , :collate=>"utf8_bin", :null=>false
      t.string   "access_level",            :limit => 60
      t.datetime "created_at"
    end

    add_index "irm_data_accesses_t", ["business_object_id","source_person_id","target_person_id"], :unique => true, :name => "IRM_DATA_ACCESSES_T_U1"

    execute("INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v")
  end

  def down
    drop_table  :irm_data_accesses_t
  end
end
