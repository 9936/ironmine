class AddReferenceFlagToRelations < ActiveRecord::Migration
  def up
    add_column :skm_entry_books_relations, :reference_flag, :string, :limit => 1, :default => 'N', :after => :target_id
  end

  def down
    remove_column :skm_entry_books_relations, :reference_flag
  end
end
