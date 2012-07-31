module Chm::ChangeRequestsHelper
  def change_incident_requests(change_request_id)
    incident_request_ids = Chm::ChangeIncidentRelation.where(:change_request_id=>change_request_id,:create_flag=>Irm::Constant::SYS_NO).collect{|i| i.incident_request_id}
    Icm::IncidentRequest.list_all.query_by_ids(incident_request_ids)
  end

  def change_master_incident_request(incident_request_id)
     Icm::IncidentRequest.list_all.query(incident_request_id).first
  end

  def change_incident_show(change_requests, change_request_id)
    html = ""
    if !change_requests.nil?
      unless change_requests.count > 1
        html << "<td class='expends vt'>"
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='header-name'>[#{change_requests[0][:request_number]}] #{link_to(change_requests[0][:title], {:controller => 'change_requests', :action => 'show_incident', :id=> change_request_id}, {:style => 'display: inline;'})}</div></td>
                          </tr>
                        </table>
                      </div>"
      else
        html<< "<td class='vt'><div>
                 <a class='expand-icon' href='javascript:void(0);' title='expand'>expand</a>
                 <a class='collapse-icon' href='javascript:void(0);' title='collapse'>collapse</a>
               </div></td>"
        html << "<td class='expends'>"
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='header-name'> #{change_requests.count}</div></td>
                          </tr>
                        </table>
                      </div>"
        change_requests.each do |cr|
          html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                            <tr>
                              <td><div class='name'>[#{cr[:request_number]}] #{link_to(cr[:title], {:controller => 'change_requests', :action => 'show_incident', :id=> change_request_id}, {:style => 'display: inline;'})}</div></td>
                            </tr>
                          </table>
                        </div>"
        end
        html << "</td>"
      end
    end
    raw html
  end


   def change_pan_show(change_request)
     html = ""
     unless change_request.nil?
       if change_request.change_plans.present?
         if change_request.change_plans.count > 1
           html<< "<td class='vt'><div>
                 <a class='expand-icon' href='javascript:void(0);' title='expand'>expand</a>
                 <a class='collapse-icon' href='javascript:void(0);' title='collapse'>collapse</a>
               </div></td>"
           html << "<td class='expends'>"
           html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr><td><div class='header-name'> #{change_request.change_plans.count}</div></td></tr>
                      </table></div>"
           change_request.change_plans.each do  |plan|
              html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                            <tr>
                              <td><div class='name'>#{link_to(Chm::ChangePlanType.multilingual.find(plan[:change_plan_type_id])[:name], {:controller => 'change_requests', :action => 'show_plan', :id=> change_request.id}, {:style => 'display: inline;'})}</div></td>
                            </tr>
                          </table>
                        </div>"
           end
         else
           html << "<td class='expends'>"
           html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='header-name'>#{link_to(Chm::ChangePlanType.multilingual.find(change_request.change_plans[0][:change_plan_type_id])[:name], {:controller => 'change_requests', :action => 'show_plan', :id=> change_request.id}, {:style => 'display: inline;'})}</div></td>
                          </tr>
                        </table>
                      </div>"
         end
         html << "</td>"
       end
     end
     raw html
   end

  def change_request_tasks(change_request_id)
    tasks = Chm::ChangeTask.list_all.where(:source_type=>Chm::ChangeRequest.name,:source_id=>change_request_id)
    html = ""
    if tasks.present?
        html<< "<td class='vt'><div>
               <a class='expand-icon' href='javascript:void(0);' title='expand'>expand</a>
               <a class='collapse-icon' href='javascript:void(0);' title='collapse'>collapse</a>
             </div></td>"
        html << "<td class='expends'>"
        tasks.each do |task|
          html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td>#{get_stage_icon_by_value(task[:status], task[:name])}</td>
                            <td><div class='name'>[#{task[:status_name]}]#{link_to(task[:name], {:controller => 'change_requests', :action => 'show_implement', :id=> change_request_id}, {:style => 'display:block;'})}</div></td>
                          </tr>
                        </table>
                      </div>"
        end
        html << "</td>"
    end
    raw html
  end

  # build the stage collapse
  def build_stage_collapse(stage_id)
    stages = Chm::ChangeStatus.multilingual.enabled
    html = ""
    current_index = -1
    stages.each_with_index do |stage,index|
      if stage.id.eql?(stage_id)
        current_index = index
        if index == 0
          html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                      <tr>
                        <td><div class='workflow requested' title='#{stage[:name]}'></div></td>
                        <td><div class='name'>#{stage[:name]}</div></td>
                      </tr>
                    </table>
                  </div>"
        else
          html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow active' title='#{stage[:name]}'></div></td>
                            <td><div class='name'>#{stage[:name]}</div></td>
                          </tr>
                        </table>
                      </div>"
        end
      else
        if index > current_index and current_index > -1
            html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow pending' title='#{stage[:name]}'></div></td>
                            <td><div class='name'>#{stage[:name]}</div></td>
                          </tr>
                        </table>
                      </div>"
        else
           html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow complete' title='#{stage[:name]}'></div></td>
                            <td><div class='name'>#{stage[:name]}</div></td>
                          </tr>
                        </table>
                      </div>"
        end
      end
    end
    raw html
  end

  def get_stage_icon_by_value(stage_id, task_name=nil)
    stages = Chm::ChangeStatus.multilingual.enabled
    current_index = 0
    current_value = ""
    stages.each_with_index do |stage,index|
       if stage.id.eql?(stage_id)
          current_index = index
          current_value = stage[:name]
          break
       end
    end
    case current_index
      when 0
         raw "<div class='workflow requested' title='#{task_name} [#{current_value}]'></div>"
      when 1
         raw "<div class='workflow active' title='#{task_name} [#{current_value}]'></div>"
      when 2
         raw "<div class='workflow complete' title='#{task_name} [#{current_value}]'></div>"
      when 3
         raw "<div class='workflow closed' title='#{task_name} [#{current_value}]'></div>"
      else
         raw "<div class='workflow pending' title='#{task_name} [#{current_value}]'></div>"
    end
  end

  def merge_datas(datas)
    change_requests_ids = datas.collect {|i| i.id}
    group_incidents = group_incidents_by_change_request_ids(change_requests_ids)
    datas.each do |cr|
     if group_incidents[cr[:id]].present?
        cr[:incidents] ||= []
        cr[:incidents] = group_incidents[cr[:id]]
     end
    end
    change_requests_approve(datas)
  end

  private
  #根据变更单id获取所有关联的事故单()
  def group_incidents_by_change_request_ids(cr_ids)
    changeIncidentRelations = Chm::ChangeIncidentRelation.select("incident_request_id,change_request_id").where(:change_request_id=>cr_ids,:create_flag=>Irm::Constant::SYS_NO)
    group_change_incidents = {}
    unless changeIncidentRelations.nil?
       incident_requests = Icm::IncidentRequest.select("id,request_number,title").where(:id=> changeIncidentRelations.collect{|i|i[:incident_request_id]})
       #根据变更单id对事故单进行分组
       incident_requests.each do |ir|
         changeIncidentRelations.each do |cir|
           if cir[:incident_request_id].eql?(ir[:id])
             group_change_incidents[cir[:change_request_id]] ||= []
             group_change_incidents[cir[:change_request_id]] << ir
           end
         end
       end
    end
    group_change_incidents
  end

  #根据变跟单的审批状态获取变更单当前的审批状态
  def change_requests_approve(change_requests)
    #根据状态的代码获取当前的含义
    change_approve_status = Irm::LookupValue.get_lookup_value("CHANGE_APPROVE_STATUS")
    codes_to_meanings = {}
    unless change_approve_status.nil?
       change_approve_status.each do |cas|
         codes_to_meanings[cas[:lookup_code]] ||= []
         codes_to_meanings[cas[:lookup_code]] = Irm::LookupValue.get_meaning("CHANGE_APPROVE_STATUS", cas[:lookup_code])
       end
    end
    change_requests.each do |cr|
      cr[:approve_status_meaning] ||= []
      if cr[:approve_status].present?
          cr[:approve_status_meaning] = codes_to_meanings[cr[:approve_status]]
      else
        cr[:approve_status_meaning] = t(:label_chm_change_request_approve_wait)
      end
    end
    change_requests
  end
end
