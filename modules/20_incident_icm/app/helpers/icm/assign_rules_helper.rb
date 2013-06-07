module Icm::AssignRulesHelper
  def support_group_name(support_group_id)
    if support_group_id.present?
      group_id = Icm::SupportGroup.find(support_group_id).group_id
      group = Irm::Group.multilingual.query(group_id).first
      group[:name]
    end
  end

  def available_support_groups(sid='')
    support_group = Icm::SupportGroup.with_system(sid)
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
      html += duel_meaning(assignments,support_group_duel_values).join(" <span class='label' style='line-height:20px;'>#{join_type}</span> ")
    end
    html.html_safe
  end

  def assign_rule_attributes(custom_hash, join_type)
    html = ""

    bo = Irm::BusinessObject.with_custom_flag.where(:bo_model_name => "Icm::IncidentRequest").first

    total_count = custom_hash.size
    current_count = 0
    custom_hash.each do |k, v|
      current_count += 1
      case k.to_s
        when "incident_category_id"
          html += "#{t :label_icm_incident_request_incident_category} ==> #{Icm::IncidentCategory.multilingual.enabled.find(v)[:name]}"
        when "incident_sub_category_id"
          html += "#{t :label_icm_incident_request_incident_sub_category} ==> #{Icm::IncidentSubCategory.multilingual.enabled.find(v)[:name]}"
        when "urgence_id"
          html += "#{t :label_icm_incident_request_urgence_code} ==> #{Icm::UrgenceCode.multilingual.find(v)[:name]}"
        when "impact_range_id"
          html += "#{t :label_icm_incident_request_impact_range_code} ==> #{Icm::ImpactRange.multilingual.find(v)[:name]}"
        else
          if bo.present?
            attribute = Irm::ObjectAttribute.where("attribute_name=?", k).multilingual.query_by_business_object(bo.id).with_external_system(current_system.id).first
          end
          html += "#{attribute[:name]} ==> #{v}" if attribute.present?
      end
      if total_count > current_count
        html += " <span class='label' style='line-height:20px;'>#{join_type}</span> <br/>"
      end
    end
    html.html_safe
  end

end
