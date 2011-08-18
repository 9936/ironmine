module Irm::SupportGroupsHelper
  def available_parent_support_groups(support_group_id=nil)
    all_groups = Irm::SupportGroup.list_all
    return all_groups.collect{|m| [m[:name],m.id]} unless support_group_id.present?
    grouped_groups = all_groups.collect{|i| [i.id,i.parent_group_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    proc = Proc.new{|parent_group_id|
      all_groups.delete_if{|i| i.id.to_s.eql?(parent_group_id.to_s)}
      if(grouped_groups[parent_group_id.to_s]&&grouped_groups[parent_group_id.to_s].any?)
        grouped_groups[parent_group_id.to_s].each do |r|
          all_groups.delete_if{|i| i.id.to_s.eql?(r[0])}
          proc.call(r[0])
        end
      end
    }
    proc.call(support_group_id)
    all_groups.collect{|m| [m[:name],m.id]}
  end
end
