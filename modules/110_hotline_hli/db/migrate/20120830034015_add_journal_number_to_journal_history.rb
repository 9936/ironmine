class AddJournalNumberToJournalHistory < ActiveRecord::Migration
  def change
    add_column :icm_journal_histories, :source_journal_number, :string, :limit => 30
  end
end
