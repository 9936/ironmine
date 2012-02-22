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
        html << "<td class='expends'>"
        html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><span class='header_name'>[#{change_requests[0][:request_number]}] #{link_to(change_requests[0][:title], {:controller => 'change_requests', :action => 'show_incident', :id=> change_request_id}, {:style => 'display: inline;'})}</span></td>
                          </tr>
                        </table>
                      </span>"
      else
        html<< "<td><span>
                 <a class='expand_icon' href='javascript:void(0);' title='expand'>expand</a>
                 <a class='collapse_icon' href='javascript:void(0);' title='collapse'>collapse</a>
               </span></td>"
        html << "<td class='expends'>"
        html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><span class='header_name'> #{change_requests.count}</span></td>
                          </tr>
                        </table>
                      </span>"
        change_requests.each do |cr|
          html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                            <tr>
                              <td><span class='name'>[#{cr[:request_number]}] #{link_to(cr[:title], {:controller => 'change_requests', :action => 'show_incident', :id=> change_request_id}, {:style => 'display: inline;'})}</span></td>
                            </tr>
                          </table>
                        </span>"
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
           html<< "<td><span>
                 <a class='expand_icon' href='javascript:void(0);' title='expand'>expand</a>
                 <a class='collapse_icon' href='javascript:void(0);' title='collapse'>collapse</a>
               </span></td>"
           html << "<td class='expends'>"
           html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr><td><span class='header_name'> #{change_request.change_plans.count}</span></td></tr>
                      </table></span>"
           change_request.change_plans.each do  |plan|
              html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                            <tr>
                              <td><span class='name'>#{link_to(Chm::ChangePlanType.multilingual.find(plan[:change_plan_type_id])[:name], {:controller => 'change_requests', :action => 'show_plan', :id=> change_request.id}, {:style => 'display: inline;'})}</span></td>
                            </tr>
                          </table>
                        </span>"
           end
         else
           html << "<td class='expends'>"
           html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><span class='header_name'>#{link_to(Chm::ChangePlanType.multilingual.find(change_request.change_plans[0][:change_plan_type_id])[:name], {:controller => 'change_requests', :action => 'show_plan', :id=> change_request.id}, {:style => 'display: inline;'})}</span></td>
                          </tr>
                        </table>
                      </span>"
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
        html<< "<td><span>
               <a class='expand_icon' href='javascript:void(0);' title='expand'>expand</a>
               <a class='collapse_icon' href='javascript:void(0);' title='collapse'>collapse</a>
             </span></td>"
        html << "<td class='expends'>"
        tasks.each do |task|
          html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td>#{get_stage_icon_by_value(task[:status], task[:name])}</td>
                            <td><span class='name'>[#{task[:status_name]}]#{link_to(task[:name], {:controller => 'change_requests', :action => 'show_implement', :id=> change_request_id}, {:style => 'display:block;'})}</span></td>
                          </tr>
                        </table>
                      </span>"
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
          html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                      <tr>
                        <td><span class='workflow requested' title='#{stage[:name]}'></span></td>
                        <td><span class='name'>#{stage[:name]}</span></td>
                      </tr>
                    </table>
                  </span>"
        else
          html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><span class='workflow active' title='#{stage[:name]}'></span></td>
                            <td><span class='name'>#{stage[:name]}</span></td>
                          </tr>
                        </table>
                      </span>"
        end
      else
        if index > current_index and current_index > -1
            html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><span class='workflow pending' title='#{stage[:name]}'></span></td>
                            <td><span class='name'>#{stage[:name]}</span></td>
                          </tr>
                        </table>
                      </span>"
        else
           html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><span class='workflow complete' title='#{stage[:name]}'></span></td>
                            <td><span class='name'>#{stage[:name]}</span></td>
                          </tr>
                        </table>
                      </span>"
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
         raw "<span class='workflow requested' title='#{task_name} [#{current_value}]'></span>"
      when 1
         raw "<span class='workflow active' title='#{task_name} [#{current_value}]'></span>"
      when 2
         raw "<span class='workflow complete' title='#{task_name} [#{current_value}]'></span>"
      when 3
         raw "<span class='workflow closed' title='#{task_name} [#{current_value}]'></span>"
      else
         raw "<span class='workflow pending' title='#{task_name} [#{current_value}]'></span>"
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
    datas
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
end
