module Icm::SystemsHelper
  def support_group_systems_num(support_group_id)
    record = Icm::ExternalSystemGroup.systems_num(support_group_id).first
    num = record[:system_count] if record.present?
    num ||= 1
    num
  end
end