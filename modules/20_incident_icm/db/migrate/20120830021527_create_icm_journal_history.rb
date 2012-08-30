class CreateIcmJournalHistory < ActiveRecord::Migration
  def up
    create_table :icm_journal_histories, :force => true do |t|
      t.string   "opu_id",        :limit => 22 , :collate=>"utf8_bin"
      t.string   "incident_history_id", :limit => 22, :collate=>"utf8_bin"
      t.string   "incident_journal_id", :limit => 22, :collate=>"utf8_bin"
      t.text     "message_body"
      t.string   "source_updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "source_updated_at"
      t.string   "status_code",      :limit => 30, :default => "ENABLED",:null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :icm_journal_histories, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end

  def down
    drop_table :icm_journal_histories
  end
end
