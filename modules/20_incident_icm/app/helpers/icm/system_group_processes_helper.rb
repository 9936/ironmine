module Icm::SystemGroupProcessesHelper
  def system_categories(external_system_id)
    Icm::IncidentCategory.multilingual.enabled.query_by_system(external_system_id).order("display_sequence ASC").collect{|i| [i[:name],i.id]}
  end

  def support_group_process_rows(sid)
    Icm::ExternalSystemGroup.with_groups(I18n.locale).with_system(sid)
  end


  def current_group_process_data(group_process_id)
    processes = Icm::GroupProcessRelation.where(:group_process_id => group_process_id)
    result = {}
    processes.each do |process|
      result[process.support_group_from] ||= []
      result[process.support_group_from] << process.support_group_to
    end
    result
  end
end
