class CreateApiParams < ActiveRecord::Migration
  def up
    create_table :irm_api_params, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "permission_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "method", :limit => 20, :default => "GET"
      t.string   "name", :limit => 30
      t.string   "param_type", :limit => 20, :default => "String"
      t.string   "param_classify", :limit => 10, :default => "INPUT"
      t.string   "required_flag", :limit => 1, :default => "N"
      t.string   "example_value", :default => nil
      t.string   "default_value", :default => nil
      t.text     "description"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_api_params, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
    drop_table :irm_api_params
  end

end
