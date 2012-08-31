class Icm::JournalHistory < ActiveRecord::Base
  set_table_name :icm_journal_histories

  has_one :incident_journal
  has_one :incident_history
end
