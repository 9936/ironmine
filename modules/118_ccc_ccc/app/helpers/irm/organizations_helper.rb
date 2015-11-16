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

  # 将组织数据以树形展示
  def org_tree_data
    organizations = Irm::Organization.multilingual.enabled.order("id")
    datas = {:root=>[]}
    organizations.each do |org|
      if org.parent_org_id.present?
        datas[org.parent_org_id] ||= []
        datas[org.parent_org_id] << org
      else
        datas[:root] << org
      end
    end

    ul_html = "<ul id='organizations' class='treeview-red'>"

    datas[:root].each do |org|
      ul_html << org_tree_build(org,datas)
    end
    ul_html << "</ul>"
    raw ul_html
  end

  def org_tree_build(org,datas)
    li_html = ""
    if datas[org.id].present?
      li_html << "<li>
                    <span class='name' >#{org[:name]}</span>
                    <span class='actions'>#{link_to(t(:edit),{:action => "edit", :id => org[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span> |
                    <span class='actions'>#{link_to(t(:show),{:action => "show", :id => org[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span>
                    <ul>"
      li_html << "<li><span class='actions add-child'>#{link_to(t(:new),{:action => "new", :parent_id => org[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span></li>"
      datas[org.id].each do |sub_org|
        li_html << org_tree_build(sub_org,datas)
      end
      li_html << "</ul></li>"
    else
      li_html << "<li>
                    <span class='name'>#{org[:name]}</span>
                    <span class='actions'>#{link_to(t(:edit),{:action => "edit", :id => org[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span> |
                    <span class='actions'>#{link_to(t(:show),{:action => "show", :id => org[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span>"

      li_html << "<ul><li><span class='actions add-child'>#{link_to(t(:new),{:action => "new", :parent_id => org[:id]}, {:onclick => 'event.stopPropagation()||(event.cancelBubble = true);'}) }</span></li>"
      li_html << "</ul></li>"
    end
    li_html
  end

  def available_industry
    all_Industries = Ccc::Industry.enabled.multilingual
    all_Industries.collect{|i|[i[:name],i.id]}
  end

  def available_connect
    all_connTypes = Ccc::ConnType.enabled.multilingual
    all_connTypes.collect{|i|[i[:name],i.id]}
  end

end
