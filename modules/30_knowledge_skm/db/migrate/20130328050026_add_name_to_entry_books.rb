class AddNameToEntryBooks < ActiveRecord::Migration
  def up
    add_column :skm_entry_books_relations, :display_name, :string, :default => '', :after => :target_id
  end

  def down
    remove_column :skm_entry_books_relations, :display_name
  end
end
