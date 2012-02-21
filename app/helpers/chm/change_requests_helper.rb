module Chm::ChangeRequestsHelper
  def change_incident_requests(change_request_id)
    incident_request_ids = Chm::ChangeIncidentRelation.where(:change_request_id=>change_request_id,:create_flag=>Irm::Constant::SYS_NO).collect{|i| i.incident_request_id}
    Icm::IncidentRequest.list_all.query_by_ids(incident_request_ids)
  end

  def change_master_incident_request(incident_request_id)
     Icm::IncidentRequest.list_all.query(incident_request_id).first
  end

  def change_incident_show(change_request_id)
    change_requests = change_incident_requests(change_request_id)
    html = ""
    if change_requests.present?
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
                 <a class='expand_icon' href='javascript:void(0);'><img src='/images/filter_hide.gifx'></a>
                 <a class='collapse_icon' style='display: none' href='javascript:void(0);'><img src='/images/filter_reveal.gifx'></a>
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
                 <a class='expand_icon' href='javascript:void(0);'><img src='/images/filter_hide.gifx'></a>
                 <a class='collapse_icon' style='display: none' href='javascript:void(0);'><img src='/images/filter_reveal.gifx'></a>
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
               <a class='expand_icon' href='javascript:void(0);'><img src='/images/filter_hide.gifx'></a>
               <a class='collapse_icon' style='display: none' href='javascript:void(0);'><img src='/images/filter_reveal.gifx'></a>
             </span></td>"
        html << "<td class='expends'>"
        tasks.each do |task|
          html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td>#{get_stage_icon_by_value(task[:status])}</td>
                            <td><span class='name'>[ #{task[:status_name]} ]#{link_to(task[:name], {:controller => 'change_requests', :action => 'show_implement', :id=> change_request_id}, {:style => 'display:block;'})}</span></td>
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
                        <td><img src='/images/workflow_requested.gif' title='#{stage[:name]}'></td>
                        <td><span class='name'>#{stage[:name]}</span></td>
                      </tr>
                    </table>
                  </span>"
        else
          html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><img src='/images/workflow_active.gif' title='#{stage[:name]}'></td>
                            <td><span class='name'>#{stage[:name]}</span></td>
                          </tr>
                        </table>
                      </span>"
        end
      else
        if index > current_index and current_index > -1
            html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><img src='/images/workflow_pending.gif' title='#{stage[:name]}'></td>
                            <td><span class='name'>#{stage[:name]}</span></td>
                          </tr>
                        </table>
                      </span>"
        else
           html << "<span><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><img src='/images/workflow_complete.gif' title='#{stage[:name]}'></td>
                            <td><span class='name'>#{stage[:name]}</span></td>
                          </tr>
                        </table>
                      </span>"
        end
      end
    end
    raw html
  end

  def get_stage_icon_by_value(stage_id)
    stages = Chm::ChangeStatus.multilingual.enabled
    current_index = 0

    stages.each_with_index do |stage,index|
       if stage.id.eql?(stage_id)
          current_index = index
          break
       end
    end
    case current_index
      when 0
         raw "<img src='/images/workflow_requested.gif'>"
      when 1
         raw "<img src='/images/workflow_active.gif'>"
      when 2
         raw "<img src='/images/workflow_complete.gif'>"
      when 3
         raw "<img src='/images/workflow_approval_rejected.gif'>"
      else
         raw "<img src='/images/workflow_pending.gif'>"
    end
  end
end
