class Icm::IncidentWorkload < ActiveRecord::Base
  set_table_name :icm_incident_workloads
  belongs_to :incident_request
  belongs_to :person, :class_name => "Irm::Person"
  attr_accessor :person_name
  query_extend
end
