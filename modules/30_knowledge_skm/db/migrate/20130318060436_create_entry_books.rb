class CreateEntryBooks < ActiveRecord::Migration
  def up
    create_table :skm_entry_books, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :skm_entry_books, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :skm_entry_books_tl, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "book_id", :limit => 22, :collate => "utf8_bin"
      t.string "language", :limit => 30, :null => false
      t.string "name", :limit => 150
      t.string "description", :limit => 240
      t.string "source_lang", :limit => 30, :null => false
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :skm_entry_books_tl, "id", :string, :limit => 22, :collate => "utf8_bin"

    add_index "skm_entry_books_tl", ["book_id", "language"], :name => "SKM_BOOKS_TL_U1", :unique => true
    add_index "skm_entry_books_tl", ["book_id"], :name => "SkM_BOOKS_TL_N1"

    execute('CREATE OR REPLACE VIEW skm_entry_books_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
             FROM skm_entry_books t, skm_entry_books_tl tl WHERE t.id = tl.book_id')

    create_table :skm_entry_books_relations, :force => true do |t|
      t.string "opu_id", :limit => 22, :collate => "utf8_bin"
      t.string "book_id", :limit => 22, :collate => "utf8_bin"
      t.string "relation_type", :limit => 30, :null => false
      t.string "target_id", :limit => 22, :collate => "utf8_bin"
      t.integer "display_sequence", :default => 1
      t.string "status_code", :limit => 30, :null => false
      t.string "created_by", :limit => 22, :collate => "utf8_bin"
      t.string "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :skm_entry_books_relations, "id", :string, :limit => 22, :collate => "utf8_bin"
  end

  def down
    drop_table :skm_entry_books
    drop_table :skm_entry_books_tl
    execute('DROP VIEW skm_entry_books_vl')
    drop_table :skm_entry_books_relations
  end
end
