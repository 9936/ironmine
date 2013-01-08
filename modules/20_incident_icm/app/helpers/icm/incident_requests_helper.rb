module Icm::IncidentRequestsHelper
  def available_service(external_system_id=nil)
    services = []
    if external_system_id && !external_system_id.blank?
      services_scope = Slm::ServiceCatalog.multilingual.enabled.query_by_external_system(external_system_id)
      services = services_scope.collect{|i| [i[:name], i.catalog_code]}
    end
    services
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

  def available_support_group(sid = '')
    if sid.present?
      all_groups = Icm::SupportGroup.enabled.oncall.with_group(I18n.locale).with_system(sid).select_all
    else
      all_groups = Icm::SupportGroup.enabled.oncall.with_group(I18n.locale).select_all
    end

    all_groups.collect{|i|[i[:name], i[:id]]}
  end

  def available_support_group_relation_group(sid = '')
    if sid.present?
      all_groups = Icm::SupportGroup.enabled.oncall.with_group(I18n.locale).with_system(sid).select_all
    else
      all_groups = Icm::SupportGroup.enabled.oncall.with_group(I18n.locale).select_all
    end

    all_groups.collect{|i|[i[:name], i[:group_id]]}
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
        d2 = content_tag(:td, a.data_file_name, :class => "data-col")
        d3 = content_tag(:td, a.description, :class => "data-col")
        d4 = content_tag(:td, link_to(t(:delete), {:controller => "icm/incident_requests",
                                                   :action => "remove_exists_attachments",
                                                   :att_id => a.id, :incident_request_id => incident_request.id},
                                      :remote => "true", :confirm => t(:label_are_you_sure)), :class => "dataCol")
        r = content_tag(:tr, d1 + d2 + d3 + d4)
        html << r
      end
    end
    raw(html)
  end

  def available_incident_relations(incident_request_id)
    if incident_request_id
      relation_list = Icm::IncidentRequestRelation.list_all(incident_request_id)
    else
      relation_list= []
    end
    relation_list.each do |r|
      if r.relation_type.to_s.eql?("CHILD")
        r.relation_type = "PARENT" if incident_request_id.to_s.eql?(r.target_id.to_s)
      elsif r.relation_type.to_s.eql?("PARENT")
        r.relation_type = "CHILD"  if incident_request_id.to_s.eql?(r.target_id.to_s)
      end
    end
    relation_list
  end


  def list_all_icm_incident_relations(incident_request_id, incident_request = nil, sid = "")
    relation_list = Icm::IncidentRequestRelation.list_all(incident_request_id)
    ret = ""

    group_relation_list = {}
    relation_list.each do |r|
      type = r.relation_type
      if r.relation_type.to_s.eql?("CHILD")
        type = "PARENT" if incident_request_id.to_s.eql?(r.target_id.to_s)
      elsif r.relation_type.to_s.eql?("PARENT")
        type = "CHILD"  if incident_request_id.to_s.eql?(r.target_id.to_s)
      end
      group_relation_list[type] ||= []
      group_relation_list[type] << r
    end

    group_relation_list.each do |key, gr|
       ret << content_tag(:tr,
                  content_tag(:td,
                      content_tag(:div,
                          Irm::LookupValue.get_meaning("ICM_INCIDENT_REQUEST_REL_TYPE", key) + ':',
                          {:style => "font-weight:bold;font-size:1.1em; margin:5px auto 3px auto;"})))
       gr.each do |w|
         if can_relation?(incident_request)
           delete_content = (icon_link_delete({:controller => "icm/incident_requests",
                             :action => "remove_relation",:sid=>sid,
                             :source_id => w[:source_id],
                             :id => w[:relation_id],:_dom_id=>"relation_list"},
                             :remote => true,
                             :style => "float: left;margin:auto 2px auto 5px;",
                             :confirm => t(:label_are_you_sure)))
         else
           delete_content = ""
         end
          ret << content_tag(:tr,
                  content_tag(:td,
                              delete_content +
                              content_tag(:div,
                                          link_to(w[:request_number] + "#" + w[:title], {:controller => "icm/incident_journals", :action => "new", :request_id => w[:request_id]},
                                                  {:class => "request_info ellipsis",:style => "width:150px;",:title=>w[:request_number] + "#" + w[:title], :request_id => w[:request_id], :request_name => w[:request_number] + "#" + w[:title]}),
                                          {:style => "float:left;"}) + raw("&nbsp;") ,

                              {:style=>"display:block;white-space:nowrap;"}
                  ))
       end
    end
    raw(ret)
  end

  def count_assign_me(person)
    incident_requests_scope = Icm::IncidentRequest.
        where("LENGTH(external_system_id) > 0").
        where("external_system_id IN (?)", person.system_ids).
        assignable_to_person(person.id).
        order("created_at")

    return incident_requests_scope.size.to_s
  end
end
