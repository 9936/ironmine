class ChangeEntryBooksColumn < ActiveRecord::Migration
  def change
    change_column_default(:skm_entry_books, :project_id, '-1')

    Skm::EntryBook.where("project_id is null").update_all(:project_id => "-1")
  end

end
