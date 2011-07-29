module Irm::ReportTriggersHelper
  def available_report_receiver_type
    [Irm::Person.name,Irm::Role.name].collect{|i| [Irm::BusinessObject.class_name_to_meaning(i),Irm::BusinessObject.class_name_to_code(i)]}
  end

  def available_report_receiver
    values = []
    values +=Irm::Person.query_by_company_ids(Irm::Person.current.accessable_company_ids).collect{|p| ["#{Irm::BusinessObject.class_name_to_meaning(Irm::Person.name)}:#{p.full_name}","#{Irm::BusinessObject.class_name_to_code(Irm::Person.name)}##{p.id}",{:type=>Irm::BusinessObject.class_name_to_code(Irm::Person.name),:query=>p.full_name}]}
    values +=Irm::Role.multilingual.enabled.collect{|r| ["#{Irm::BusinessObject.class_name_to_meaning(Irm::Role.name)}:#{r[:name]}","#{Irm::BusinessObject.class_name_to_code(Irm::Role.name)}##{r.id}",{:type=>Irm::BusinessObject.class_name_to_code(Irm::Role.name),:query=>r[:name]}]}
    values
  end
end
