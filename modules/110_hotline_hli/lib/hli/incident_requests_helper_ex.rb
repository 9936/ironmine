module Hli::IncidentRequestsHelperEx
  def self.included(base)
    base.class_eval do
      def available_support_group(source_org_id = nil, untree = false, source_external_system_id = nil)
    #    Icm::SupportGroup.enabled.oncall.with_group(I18n.locale).select_all.collect{|s| [s[:name],s.id]}
        source_org_ids = []
        if !source_external_system_id.nil?
          ex = Irm::ExternalSystem.find(source_external_system_id)
          org = Irm::Organization.where("short_name = ?", ex.external_system_code)
          if org.any?
            source_org_ids << org.first.id
          end
        end
        source_org_ids << source_org_id unless source_org_id.nil?
        all_groups = Icm::SupportGroup.enabled.oncall.with_group(I18n.locale).select_all
        all_groups = all_groups.
            joins(",#{Irm::DataShareRule.table_name} dsr").
            joins(",#{Irm::BusinessObject.table_name} bo").
            where("bo.id = dsr.business_object_id").
            where("bo.bo_model_name = ?", Icm::IncidentRequest.name).
            where("dsr.source_type = ?", "IRM__ORGANIZATION").
            where("dsr.source_id IN (?)", source_org_ids).
            where("dsr.target_type = ?", "IRM__GROUP").
            where("dsr.target_id = #{Icm::SupportGroup.table_name}.group_id") unless source_org_ids.size == 0

        return all_groups.collect{|i|[i[:name],i.id]} if untree

        grouped_groups = all_groups.collect{|i| [i.id,i.parent_group_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}
        groups = {}
        all_groups.each do |ao|
          groups.merge!({ao.id=>ao})
        end
        leveled_groups = []
        proc = Proc.new{|parent_id,level|
          if(grouped_groups[parent_id.to_s]&&grouped_groups[parent_id.to_s].any?)
            grouped_groups[parent_id.to_s].each do |o|
              groups[o[0]].level = level
              leveled_groups << groups[o[0]]

              proc.call(groups[o[0]].id,level+1)
            end
          end
        }

        return [] unless grouped_groups["blank"]&&grouped_groups["blank"].any?
        grouped_groups["blank"].each do |go|
          groups[go[0]].level = 1
          leveled_groups << groups[go[0]]
          proc.call(groups[go[0]].id,2)
        end
        leveled_groups.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}
      end
    end
  end
end