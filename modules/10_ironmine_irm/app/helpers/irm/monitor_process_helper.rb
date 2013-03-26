module Irm::MonitorProcessHelper
  def process_status_name(num)
    if num.to_i > 0
      return t(:label_irm_monitor_proces_started)
    else
      return t(:label_irm_monitor_proces_stoped)
    end
  end

  def generate_tbody(processes)
    html = ""
    processes.each do |process|
      if process[:num] && process[:num] > 0
        tr_class = 'success'
        status_name = "<span class='badge badge-success'><i class='icon-ok icon-white'></i>#{t(:label_irm_monitor_proces_started)}</span>"
        action_link = link_to(t(:label_irm_monitor_proces_stop), {:controller => "irm/monitor_process", :action => "stop_process", :id => process[:id], :_dom_id => "process_monitor" }, :class => "action-link", :remote => true)
      else
        tr_class = 'error'
        status_name = "<span class='badge badge-important'><i class='icon-remove icon-white'></i>#{t(:label_irm_monitor_proces_stoped)}</span>"
        if process[:id].eql?("delayed_job")
          action_link = link_to(t(:label_irm_monitor_proces_start), {:controller => "irm/monitor_process", :action => "start_process", :id => process[:id], :_dom_id => "process_monitor" }, :class => "action-link", :id => "delayed_job_start")
        else
         action_link = link_to(t(:label_irm_monitor_proces_start) , {:controller => "irm/monitor_process", :action => "start_process", :id => process[:id], :_dom_id => "process_monitor" }, :class => "action-link", :remote => true)
        end
      end

      html += "<tr class='#{tr_class}'>"
      html += "<td><div>#{process[:name]}</div></td>"
      html += "<td><div>#{status_name}</div></td>"
      html += "<td><div>#{process[:num]}</div></td>"
      html += "<td><div>#{action_link}</div></td>"
      html+= "</tr>"
    end

    html.html_safe
  end
end
