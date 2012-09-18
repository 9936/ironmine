module Icm::AssignRulesHelper
  def support_group_name(support_group_id)
    if support_group_id.present?
      group_id = Icm::SupportGroup.find(support_group_id).group_id
      group = Irm::Group.multilingual.query(group_id).first
      group[:name]
    end
  end

  def available_support_groups
    support_group = Icm::SupportGroup.all
    support_group_ids = support_group.collect(&:group_id)
    groups = Irm::Group.multilingual.where(:id => support_group_ids).index_by{|g|g.id}
    result = []
    support_group.each do |sg|
      result << [groups[sg[:group_id]][:name] ,sg.id]
    end
    result
  end

  def filter_and_type(assignments, join_type)
    html = ''
    if assignments.present? and join_type.present?
      html += duel_meaning(assignments,support_group_duel_values).join(" #{join_type} ")
    end
    html.html_safe
  end

end
