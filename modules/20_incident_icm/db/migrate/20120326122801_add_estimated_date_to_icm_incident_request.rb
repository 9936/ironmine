class AddEstimatedDateToIcmIncidentRequest < ActiveRecord::Migration
  def change
    add_column :icm_incident_requests, :estimated_date, :date, :after => :last_response_date
  end
end
