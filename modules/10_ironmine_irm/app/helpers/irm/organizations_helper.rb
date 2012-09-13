module Irm::OrganizationsHelper
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


  def available_parentable_organization(org_id=nil)
    unless org_id.present?
      return available_organization
    end
    all_organizations = Irm::Organization.enabled.parentable(org_id).multilingual

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

    return [] unless grouped_organizations["blank"]&&grouped_organizations["blank"].any?
    grouped_organizations["blank"].each do |go|
      organizations[go[0]].level = 1
      leveled_organizations << organizations[go[0]]
      proc.call(organizations[go[0]].id,2)
    end

    leveled_organizations.collect{|i| [(level_str(i.level)+i[:name]).html_safe,i.id]}

  end

  def level_str(level=1)
    if level.eql?(1)
      return ""
    else
      s = ""
      (level-1).times do
        s << "&nbsp;&nbsp;&nbsp;&nbsp;"
      end
    end
    s
  end



  def current_person_accessible_organizations_full
    accesses = Irm::CompanyAccess.query_by_person_id(Irm::Person.current.id).collect{|c| c.accessable_company_id}
    accessable_organizations = Irm::Organization.multilingual.query_wrap_info(I18n.locale).enabled.where("#{Irm::Organization.table_name}.company_id IN (?)", accesses)
    accessable_organizations.collect{|p| [p[:company_name] + "-" + p[:name], p.id]}
  end



end
