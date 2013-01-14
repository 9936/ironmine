module Icm::SystemGroupProcessesHelper
  def system_categories(external_system_id)
    Icm::IncidentCategory.multilingual.enabled.query_by_system(external_system_id).order("display_sequence ASC").collect{|i| [i[:name],i.id]}
  end

  def support_group_process_rows(sid)
    Icm::ExternalSystemGroup.with_groups(I18n.locale).with_system(sid)
  end
end
