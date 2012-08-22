class AddHotlinefix < ActiveRecord::Migration
  def up
    add_column :irm_external_systems, :hotline_flag, :string, :limit => 1, :after => :opu_id, :default => 'Y'
    add_column :irm_reports, :attachment_version_id, :string, :limit => 22, :after => :opu_id
    add_column :icm_incident_journals, :journal_number, :string, :limit => 30, :after => :id
    add_column :icm_incident_requests, :real_processing_time, :integer, :limit => 11, :after => :close_reason_id, :default => 0
    add_column :icm_incident_requests, :reply_count, :integer, :default => 0, :null => false, :after => :submitted_date
    add_column :icm_incident_requests, :client_info, :string, :limit => 150, :after => :summary
    add_column :icm_incident_requests, :hotline, :string, :limit => 1, :default => "N", :null => false, :after => :summary
    change_column :icm_incident_requests, :contact_number, :string, :limit => 255


    create_table :icm_incident_workloads, :force =>true do |t|
      t.string   "opu_id",            :limit => 22
      t.string   "incident_request_id",          :limit => 22
      t.string   "person_id",          :limit => 22
      t.float    "real_processing_time"
      t.string   "status_code",       :limit => 30, :default => "ENABLED"
      t.string   "created_by",       :limit => 22
      t.string   "updated_by",       :limit => 22
      t.datetime "created_at"
      t.datetime "updated_at"
    end
      change_column :icm_incident_workloads, "id", :string,:limit=>22, :collate=>"utf8_bin"
      change_column :icm_incident_request_relations, "id", :string,:limit=>22, :collate=>"utf8_bin"
      change_column :icm_incident_requests, :real_processing_time, :float, :default => 0
    begin
      add_column :irm_organizations, :hotline, :string, :limit => '1', :default => 'N', :null => false
    rescue
    end

    #SET organization sequence
    opu = Irm::OperationUnit.where("short_name = ?", "Hand").first.id
    max_organization_number = Irm::Organization.find_by_sql("SELECT MAX(short_name + 0) max_number FROM irm_organizations WHERE opu_id = '#{opu}'")
    Irm::Sequence.where("object_name = ?", Irm::Organization.name).each do |t|
      t.destroy
    end
    #预留10
    Irm::Sequence.create(:opu_id => opu,
                         :object_name => Irm::Organization.name,
                         :seq_max => 0,
                         :seq_length => 5,
                         :seq_next => max_organization_number.first[:max_number].to_i + 11) if max_organization_number.any?

    #SET request sequence
    opu = Irm::OperationUnit.where("short_name = ?", "Hand").first.id
    max_incident_request_number = Icm::IncidentRequest.find_by_sql("SELECT MAX(request_number + 0) max_number FROM icm_incident_requests WHERE opu_id = '#{opu}'")
    Irm::Sequence.where("object_name = ?", Icm::IncidentRequest.name).each do |t|
      t.destroy
    end
    #预留1000
    Irm::Sequence.create(:opu_id => opu,
                         :object_name => Icm::IncidentRequest.name,
                         :seq_max => 0,
                         :seq_length => 5 ,
                         :seq_next => max_incident_request_number.first[:max_number].to_i + 1001) if max_incident_request_number.any?
    #SET journal sequence
    opu = Irm::OperationUnit.where("short_name = ?", "Hand").first.id
    max_incident_journal_number = Icm::IncidentJournal.find_by_sql("SELECT MAX(journal_number + 0) max_number FROM icm_incident_journals WHERE opu_id = '#{opu}'")
    Irm::Sequence.where("object_name = ?", Icm::IncidentJournal.name).each do |t|
      t.destroy
    end
    #预留10000
    Irm::Sequence.create(:opu_id => opu,
                         :object_name => Icm::IncidentJournal.name,
                         :seq_max => 0,
                         :seq_length => 6 ,
                         :seq_next => max_incident_journal_number.first[:max_number].to_i + 10001) if max_incident_journal_number.any?
  end

  def down
    remove_column :irm_external_systems, :hotline_flag
    remove_column :irm_reports, :attachment_version_id
    remove_column :icm_incident_journals, :journal_number
    remove_column :icm_incident_requests, :real_processing_time
    remove_column :icm_incident_requests, :reply_count
    remove_column :icm_incident_requests, :client_info
    remove_column :icm_incident_requests, :hotline
  end
end
