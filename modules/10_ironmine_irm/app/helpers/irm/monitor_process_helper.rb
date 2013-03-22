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
        status_name = t(:label_irm_monitor_proces_started)
        action_link = link_to(t(:label_irm_monitor_proces_stop), {:controller => "irm/monitor_process", :action => "stop_process", :id => process[:id], :_dom_id => "process_monitor" }, :class => "action-link", :remote => true)
      else
        tr_class = 'error'
        status_name = t(:label_irm_monitor_proces_stoped)
        action_link = link_to(t(:label_irm_monitor_proces_start) , {:controller => "irm/monitor_process", :action => "start_process", :id => process[:id], :_dom_id => "process_monitor" }, :class => "action-link", :remote => true)
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
