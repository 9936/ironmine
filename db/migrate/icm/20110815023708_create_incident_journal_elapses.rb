class CreateIncidentJournalElapses < ActiveRecord::Migration
  def self.up
    create_table :icm_incident_journal_elapses,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :incident_journal_id,:limit=>22, :null => false
      t.string   :elapse_type,:limit=>30
      t.datetime :start_at
      t.datetime :end_at
      t.integer  :distance
      t.integer  :real_distance
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :icm_incident_journal_elapses, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"

    add_column :icm_incident_requests,:next_reply_user_license,:string,:limit=>30,:after=> :last_response_date
  end

  def self.down
    drop_table :icm_incident_journal_elapses
    remove_column :icm_incident_requests,:next_reply_user_license
  end
end
