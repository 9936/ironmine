class Irm::ReportReceiver < ActiveRecord::Base
  set_table_name :irm_report_receivers


  def person_ids
    person_ids = []
    case self.receiver_type
      when Irm::Role.name
        person_ids = Irm::Person.where(:role_id=>self.receiver_id).collect{|i| i.id}
      when Irm::Person.name
        person_ids = [self.receiver_id]
    end
    person_ids
  end
end
