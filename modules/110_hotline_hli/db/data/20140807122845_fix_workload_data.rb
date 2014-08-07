class FixWorkloadData < ActiveRecord::Migration
  def up
    workloads = Icm::IncidentJournal.
        joins(",#{Icm::IncidentRequest.table_name} ir").
        select("ir.id incident_request_id, ir.request_number, #{Icm::IncidentJournal.table_name}.workload workload, #{Icm::IncidentJournal.table_name}.created_by j_created_by").
        select("#{Icm::IncidentJournal.table_name}.id incident_journal_id, #{Icm::IncidentJournal.table_name}.created_at j_created_at").
        where("ir.id = #{Icm::IncidentJournal.table_name}.incident_request_id").
        where("#{Icm::IncidentJournal.table_name}.workload is not null").
        where("#{Icm::IncidentJournal.table_name}.workload <> 0").
        where("NOT EXISTS( SELECT * FROM icm_incident_workloads iiw WHERE iiw.incident_request_id = ir.id)")

    workloads.each do |wl|
      puts("++++++++++++++++++++++++wl number[#{wl[:request_number]}], workload[#{wl[:workload]}] ")
      Icm::IncidentWorkload.create({:incident_request_id => wl[:incident_request_id],
                                    :incident_journal_id => wl[:incident_journal_id],
                                    :real_processing_time => wl[:workload],
                                    :person_id => wl[:j_created_by],
                                    :created_at =>wl[:j_created_at],
                                    :updated_at =>wl[:j_created_at],
                                    :created_by =>wl[:j_created_by],
                                    :updated_by =>wl[:j_created_by],
                                    :workload_type => 'REMOTE'})
    end


  end

  def down
  end
end
