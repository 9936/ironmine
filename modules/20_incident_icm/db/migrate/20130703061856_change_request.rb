class ChangeRequest < ActiveRecord::Migration
  def change
    change_column :icm_incident_requests, :estimated_date, :datetime
  end
end
