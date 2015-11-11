module Cons::CustomerHelper
  def available_profile(system_flag = Irm::Constant::SYS_NO)
    Irm::Profile.multilingual.enabled.where(:system_flag => system_flag).collect{|i|[i[:name],i.id]}
  end

  def available_organization
    all_organizations = Irm::Organization.enabled.multilingual
    return [] unless all_organizations.any?
    grouped_organizations = all_organizations.collect{|i| [i.id,i.parent_org_id]}.group_by{|i|i[1].present? ? i[1] : "blank"}

    organizations = {}
    all_organizations.each do |ao|
      organizations.merge!({ao.id=>ao})
    end
    leveled_organizations = []

    proc = Proc.new{|parent_id,level|
      if(grouped_organizations[parent_id.to_s]&&grouped_organizations[parent_id.to_s].any?)

        grouped_organizations[parent_id.to_s].each do |o|
          organizations[o[0]].level = level
          leveled_organizations << organizations[o[0]]

          proc.call(organizations[o[0]].id,level+1)
        end
      end
    }


    grouped_organizations["blank"].each do |go|
      organizations[go[0]].level = 1
      leveled_organizations << organizations[go[0]]
      proc.call(organizations[go[0]].id,2)
    end

    leveled_organizations.collect{|i|[(level_str(i.level)+i[:name]).html_safe,i.id]}

  end
end
