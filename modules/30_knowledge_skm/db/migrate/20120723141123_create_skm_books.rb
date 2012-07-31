class CreateSkmBooks < ActiveRecord::Migration
  def change
    create_table :skm_books do |t|
      t.string   "opu_id",            :limit => 22 , :collate=>"utf8_bin"
      t.string   "name",              :limit => 150
      t.string   "description",       :limit => 240
      t.string   "private_flag",      :limit => 1,:default=>"N"
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :skm_books, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :skm_book_wikis do |t|
      t.string   "opu_id",            :limit => 22 , :collate=>"utf8_bin"
      t.string   "book_id",           :limit => 22, :collate=>"utf8_bin"
      t.string   "wiki_id",           :limit => 22, :collate=>"utf8_bin"
      t.integer  "display_sequence",  :default=>0
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :skm_book_wikis, "id", :string,:limit=>22, :collate=>"utf8_bin"
 end
end
