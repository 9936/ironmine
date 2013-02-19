class AddJournalNumberToJournals < ActiveRecord::Migration
  def change
    begin
      add_column :icm_incident_journals, :journal_number, :string, :limit => 30, :after => :id
    rescue
      puts "the field:journal_number has already exists!"
    end
  end
end
