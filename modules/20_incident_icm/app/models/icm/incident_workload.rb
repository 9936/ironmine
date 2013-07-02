class Icm::IncidentWorkload < ActiveRecord::Base
  set_table_name :icm_incident_workloads
  belongs_to :incident_request
  belongs_to :person, :class_name => "Irm::Person"
  attr_accessor :person_name
  query_extend

  def get_workload_type(locale)
    rel = Irm::LookupValue.
        joins(",#{Irm::LookupValuesTl.table_name} lvt").
        where("lvt.language = ?", locale).
        where("lvt.lookup_value_id = #{Irm::LookupValue.table_name}.id").
        where("#{Irm::LookupValue.table_name}.lookup_code = ?", self.workload_type).
        select("lvt.meaning")
    return rel.first[:meaning] if rel.any?
    return ""
  end
end
