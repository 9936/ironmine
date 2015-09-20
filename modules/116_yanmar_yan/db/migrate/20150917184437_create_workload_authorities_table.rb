class CreateWorkloadAuthoritiesTable < ActiveRecord::Migration
  def change
    create_table :yan_workload_authorities do |t|
      t.string   "opu_id",         :limit => 22
      t.string   "ob_type",    :limit => 22, :collate=>"utf8_bin"
      t.string   "ob_id",    :limit => 22, :collate=>"utf8_bin"
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :yan_workload_authorities, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
