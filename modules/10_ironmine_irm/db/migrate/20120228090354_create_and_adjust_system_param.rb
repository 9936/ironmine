class CreateAndAdjustSystemParam < ActiveRecord::Migration
  def up
    create_table :irm_system_parameter_values do |t|
               t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
               t.string   "system_parameter_id", :limit => 22,                         :null => false
               t.string   "value",              :limit => 240
               t.datetime "img_updated_at"
               t.integer  "img_file_size"
               t.string   "img_content_type",   :limit => 60
               t.string   "img_file_name",      :limit => 60
               t.string   "status_code",      :limit => 30, :default => "ENABLED",:null => false
               t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
               t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
               t.datetime "created_at"
               t.datetime "updated_at"
             end
             change_column :irm_system_parameter_values, "id", :string,:limit=>22, :collate=>"utf8_bin"


  end

  def down
  end
end
