class CreateIrmWikis < ActiveRecord::Migration
  def change
    create_table :irm_wikis do |t|
      t.string   "opu_id",            :limit => 22 , :collate=>"utf8_bin"
      t.string   "file_name",         :limit => 240
      t.string   "name",              :limit => 150
      t.string   "description",       :limit => 240
      t.text     "table_of_content"
      t.text     "content"
      t.string   "content_format",            :limit => 30
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_wikis, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
