class CreateCategoryTypes < ActiveRecord::Migration
  def change
    create_table :sug_categories, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "code",  :limit => 30, :null => false
      t.string   "parent_id", :limit => 22, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.text     "description"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_categories, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index :sug_categories, [:parent_id, :code], :name => "SUG_CATEGORIES_N1"

  end
end
