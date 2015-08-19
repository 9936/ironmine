class CreateFmFileOperateHistoriesTable < ActiveRecord::Migration
  def up
    create_table "fm_file_operate_histories", :force => true do |t|
      t.string   "opu_id",              :limit => 22
      t.string   "operate_code",                :null => false
      t.string   "attachment_id", :limit => 22
      t.string   "version_id",    :limit => 22
      t.string   "file_name"
      t.integer  "var_num1"
      t.integer  "var_num2"
      t.integer  "var_num3"
      t.string   "var_str1",      :limit => 50
      t.string   "var_str2",      :limit => 50
      t.string   "var_str3",      :limit => 50
      t.string   "created_by",    :limit => 22
      t.string   "updated_by",    :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :fm_file_operate_histories, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
  end
end
