module Icm::IncidentRequestsHelper
  def available_service(external_system_id=nil)
    services = []
    if external_system_id && !external_system_id.blank?
      services_scope = Slm::ServiceCatalog.multilingual.enabled.query_by_external_system(external_system_id)
      services = services_scope.collect{|i| [i[:name], i.catalog_code]}
    end
    services
  end

  def available_person
    people = Irm::Person.real.order("full_name_pinyin").collect{|p|[p.name,p[:id]]}
    needed_to_replace = people.detect{|person| Irm::Person.current.id.eql?(person[1])}
    if needed_to_replace
      people.delete_if{|person| Irm::Person.current.id.eql?(person[1])}
      people.unshift([Irm::Person.current.full_name,Irm::Person.current.id])
    end
    people
  end

  def available_contact
    people = Irm::Person.real.collect{|p|[p.name,p[:id],{:phone=>p.bussiness_phone}]}
    needed_to_replace = people.detect{|person| Irm::Person.current.id.eql?(person[1])}
    if needed_to_replace
      people.delete_if{|person| Irm::Person.current.id.eql?(person[1])}
      people.unshift([Irm::Person.current.name,Irm::Person.current.id,{:phone=>Irm::Person.current.bussiness_phone}])
    end
    people
  end

  def available_supporter(group_id=nil)
    if(group_id)
      people =  Irm::GroupMember.with_person.with_support_group(I18n.locale).query_by_support_group(group_id).order_id.collect{|p|[p[:person_name],p[:person_id]]}
    else
      people =  Irm::GroupMember.with_person.with_support_group(I18n.locale).order_id.collect{|p|[p[:person_name],p[:person_id]]}
    end
    needed_to_replace = people.detect{|person| Irm::Person.current.id.eql?(person[1])}
    if needed_to_replace
      people.delete_if{|person| Irm::Person.current.id.eql?(person[1])}
      people.unshift([Irm::Person.current.name,Irm::Person.current.id])
    end
    people
  end

  def available_support_person(group_id)
    support_group_members_scope= Irm::GroupMember.select_all.with_person(I18n.locale).assignable.query_by_support_group(group_id)
    support_group_members_scope.collect{|p| [p[:person_name],p[:person_id]]}
  end

  def available_support_group
#    Icm::SupportGroup.enabled.oncall.with_group(I18n.locale).select_all.collect{|s| [s[:name],s.id]}

    all_groups = Icm::SupportGroup.enabled.oncall.with_group(I18n.locale).select_all

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

  def available_urgence_code
    Icm::UrgenceCode.multilingual.order_display.collect{|p|[p[:name],p.id]}
  end

  def available_impact_range
    Icm::ImpactRange.multilingual.order_display.collect{|p|[p[:name],p.id]}
  end

  def available_priority_code
    Icm::PriorityCode.multilingual.order(" low_weight_value").collect{|p|[p[:name],p[:priority_code]]}
  end

  def available_request_type
    Irm::LookupValue.query_by_lookup_type("ICM_REQUEST_TYPE_CODE").multilingual.order_id.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def available_request_status_code
    Icm::IncidentStatus.multilingual.query_by_close_flag(Irm::Constant::SYS_NO).order_display.collect{|i|[i[:name],i.id]}
  end

  def available_all_request_status_code
    Icm::IncidentStatus.multilingual.order_display.collect{|i|[i[:name],i.id]}
  end

  def available_request_report_source
    Irm::LookupValue.query_by_lookup_type("ICM_REQUEST_REPORT_SOURCE").multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
  end

  def wait_for_me_request_count
    Icm::IncidentRequest.query_by_support_person(Irm::Person.current.id).size()
  end

  def reply_today_count
    Icm::IncidentJournal.where("replied_by = ?", Irm::Person.current.id).where("date_format(created_at,'%Y%m%d') = ?", Time.now.strftime('%Y%m%d')).group_by{|t| t.incident_request_id}.size()
  end

  def request_submitted_today_count
    Icm::IncidentRequest.where("date_format(submitted_date,'%Y%m%d')  = ?", Time.now.strftime('%Y%m%d')).where("submitted_by = ?", Irm::Person.current.id).size()
  end

  def my_un_solved_request
    Icm::IncidentRequest.where("incident_status_code <> ? AND incident_status_code <> ?", "SOLVE_RECOVER", "CLOSE_INCIDENT").where("submitted_by = ?", Irm::Person.current.id).size()
  end

  def my_solved_request
    Icm::IncidentRequest.where("incident_status_code = ? OR incident_status_code = ?", "SOLVE_RECOVER", "CLOSE_INCIDENT").where("submitted_by = ?", Irm::Person.current.id).size()
  end

  def over_view_list
    html = ""
    @filters = Irm::RuleFilter.where("bo_code = ? and filter_type = ?", "ICM_INCIDENT_REQUESTS","PAGE_FILTER").hold.enabled
    @filters.each do |f|
      td1 = content_tag(:td, content_tag(:a, f[:filter_name], :href => url_for(:controller => "icm/incident_requests", :action => "index", :filter_id => f.id)))

      incident_requests_scope = f.generate_scope

      if !allow_to_function?(:view_all_incident_request)
        incident_requests_scope = incident_requests_scope.relate_person(Irm::Person.current.id)
      end

      td2 = content_tag(:td, incident_requests_scope.count.to_s, :class => "tdRight")
      html << content_tag(:tr, td1 + td2)
    end

    raw(html)
  end

  def list_ir_existed_attachments(incident_request)
    html = ""
    attachments = Irm::AttachmentVersion.where("source_id = ? AND source_type = ?", incident_request.id, Icm::IncidentRequest.name)
    if attachments && attachments.any?
      attachments.each do |a|
        d1 = content_tag(:td, "", :class => "dataCol")
        d2 = content_tag(:td, a.data_file_name, :class => "dataCol")
        d3 = content_tag(:td, a.description, :class => "dataCol")
        d4 = content_tag(:td, link_to(t(:delete), {:controller => "icm/incident_requests", :action => "remove_exists_attachments", :att_id => a.id, :incident_request_id => incident_request.id}, :remote => "true", :confirm => t(:label_are_you_sure)), :class => "dataCol")
        r = content_tag(:tr, d1 + d2 + d3 + d4)
        html << r
      end
    end
    raw(html)
  end

  def list_all_icm_incident_relations(incident_request_id)
    relation_list = Icm::IncidentRequestRelation.list_all(incident_request_id)
    ret = ""

    group_relation_list = {}
    relation_list.each do |r|
      group_relation_list[r.relation_type] ||= []
      group_relation_list[r.relation_type] << r
    end
    group_relation_list.each do |key, gr|
       ret << content_tag(:tr,
                  content_tag(:td,
                      content_tag(:div,
                          Irm::LookupValue.get_meaning("ICM_INCIDENT_REQUEST_REL_TYPE", key) + ':',
                          {:style => "font-weight:bold;font-size:1.1em;"})))
       gr.each do |w|
          ret << content_tag(:tr,
                  content_tag(:td,
                              content_tag(:div,
                                          link_to(w[:request_number] + "#" + w[:title], {:controller => "icm/incident_journals", :action => "new", :request_id => w[:request_id]},
                                                  {:class => "request_info", :request_id => w[:request_id], :request_name => w[:request_number] + "#" + w[:title]}),
                                          {:style => "float:left"}) + raw("&nbsp;") + (icon_link_delete({:controller => "icm/incident_requests",
                                                                                                         :action => "remove_relation",
                                                                                                         :source_id => w[:source_id],
                                                                                                         :id => w[:relation_id]}, :remote => true, :confirm => t(:label_are_you_sure)))))
       end
    end
    raw(ret)
  end
end
