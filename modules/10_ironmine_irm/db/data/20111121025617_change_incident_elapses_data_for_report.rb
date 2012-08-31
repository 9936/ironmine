class ChangeIncidentElapsesDataForReport < ActiveRecord::Migration
  def up
    # 事故单耗时数据
    Icm::IncidentJournalElapse.all.each do |elapse|
      next unless elapse.incident_journal&&elapse.incident_journal.incident_request

      elapse_options = {:incident_status_id=>elapse.incident_journal.incident_request.incident_status_id,:support_group_id=>elapse.incident_journal.incident_request.support_group_id}

      incident_histories = Icm::IncidentHistory.where(:journal_id=>elapse.incident_journal.id)

      elapse_options = {}

      status_change_history = incident_histories.detect{|i| i.property_key.eql?("incident_status_id")}

      if status_change_history
        elapse_options.merge!({:incident_status_id=>status_change_history.old_value})
      end

      support_group_change_history = incident_histories.detect{|i| i.property_key.eql?("support_group_id")}

      if support_group_change_history
        elapse_options.merge!({:support_group_id=>support_group_change_history.old_value})
      end

      elapse.update_attributes(elapse_options)
    end
  end

  def down
  end
end
