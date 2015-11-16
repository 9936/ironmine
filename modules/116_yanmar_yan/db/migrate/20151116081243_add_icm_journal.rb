class AddIcmJournal < ActiveRecord::Migration
  def up
    add_column :icm_incident_journals, :people_type, :string, :limit => 22, :after => :message_body
  end

  def down
  end
end
