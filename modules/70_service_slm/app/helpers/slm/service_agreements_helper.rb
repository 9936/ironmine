module Slm::ServiceAgreementsHelper
  #得到天数
  def get_day_count(time)
     if time.present?
       (time/86400).to_i
     end
  end

  #得到月份
  def get_hour_count(time)
    if time.present?
        ((time-((get_day_count(time))*86400)) / 60) .to_i
    end
  end

  #得到分钟
  def get_minute_count(time)
    if time.present?
       time - get_hour_count(time) * 60 - get_day_count(time)* 86400
    end
  end


  def available_service_agreement
    Slm::ServiceAgreement.multilingual.collect{|m| [m[:name], m.id]}
  end

  def checkbox_show_flag(flag)
     if(flag.present? && flag.to_i == 1)
       true
     else
       false
     end
  end

  def div_show_flag(flag)
     if(flag.present? && flag.to_i == 1)
       "display:block;"
     else
       "display:none;"
     end
  end

  def show_options(value_type,value)
    result =""
    if (value_type == 'USER')
      user_scope = Irm::Person.query_all_person
      user =  user_scope.collect{|i|[i[:person_name],i.id]}
      result =  user
    else
      role_scope = Irm::Role.multilingual.enabled
      role =  role_scope.collect{|i|[i[:name],i.id]}
      result = role
    end
    result
  end

  def show_selected(value_type,value)
    value_options = ""
    if value.present?
        if(value_type == 'USER')
          value_options = Irm::Person.query_all_person.find(value)[:person_name]
        else
          value_options = Irm::Role.multilingual.find(value)[:name]
        end
    else
      value_options=""
    end
    value_options
  end


  def service_agreement_time_triggers(service_agreement_id)
    Slm::TimeTrigger.where(:service_agreement_id=>service_agreement_id)
  end

  def service_agreement_exists_actions(service_agreement_id)
    values = []
    bo_code = Slm::ServiceAgreement.find(service_agreement_id).business_object_code

    label_name =Irm::BusinessObject.class_name_to_meaning(Irm::WfFieldUpdate.name)
    code = Irm::BusinessObject.class_name_to_code(Irm::WfFieldUpdate.name)
    values +=Irm::WfFieldUpdate.where(:bo_code=>bo_code).collect{|i| ["#{label_name}:#{i.name}","#{code}##{i.id}",{:type=>code,:query=>i.name}]}

    label_name =Irm::BusinessObject.class_name_to_meaning(Irm::WfMailAlert.name)
    code = Irm::BusinessObject.class_name_to_code(Irm::WfMailAlert.name)
    values +=Irm::WfMailAlert.where(:bo_code=>bo_code).collect{|i| ["#{label_name}:#{i.name}","#{code}##{i.id}",{:type=>code,:query=>i.name}]}

    values
  end


  def service_agreement_belongs_actions(time_trigger_id)
    action_types = [[Irm::WfFieldUpdate,Irm::BusinessObject.class_name_to_code(Irm::WfFieldUpdate.name)],[Irm::WfMailAlert,Irm::BusinessObject.class_name_to_code(Irm::WfMailAlert.name)]]
    service_agreement_actions = Slm::TimeTriggerAction.where(:time_trigger_id=>time_trigger_id)
    actions = []
    service_agreement_actions.each do |action|
      action_type = action_types.detect{|i| i[0].name.eql?(action.action_type)}
      actions<<"#{action_type[1]}##{action.action_id}"
    end
    actions.join(",")
  end


  def service_agreement_time_trigger_actions(time_trigger_id)
    service_agreement_actions = Slm::TimeTriggerAction.where(:time_trigger_id=>time_trigger_id)
    actions = []
    service_agreement_actions.each do |action|
      ref_action =  action.action_type.constantize.query(action.action_id).first
      next unless ref_action
      case action.action_type
        when Irm::WfMailAlert.name
          ref_action_options = {:action_type_name=>t("label_"+Irm::WfMailAlert.name.underscore.gsub("\/","_")),
                                :edit_url_options=>{:controller=>"irm/wf_mail_alerts",:action=>"edit",:id=>action.action_id},
                                :show_url_options=>{:controller=>"irm/wf_mail_alerts",:action=>"show",:id=>action.action_id},
                                :ref_action=>ref_action,:action=>action}
        when Irm::WfFieldUpdate.name
          ref_action_options = {:action_type_name=>t("label_"+Irm::WfFieldUpdate.name.underscore.gsub("\/","_")),
                                :edit_url_options=>{:controller=>"irm/wf_field_updates",:action=>"edit",:id=>action.action_id},
                                :show_url_options=>{:controller=>"irm/wf_field_updates",:action=>"show",:id=>action.action_id},
                                :ref_action=>ref_action,:action=>action}
      end
      actions << ref_action_options
    end
    actions
  end

  def display_service_agreements(bo_id,bo_type,sid)
    if Slm::SlaInstance.where(:bo_id=>bo_id,:bo_type=>bo_type).count>0

      render :partial=>"slm/service_agreements/display_service_agreements",:locals=>{:sid=>sid,:bo_id=>bo_id,:bo_type=>bo_type}
    end
  end

  def generate_progress_bar(current_duration, max_duration)
    current_duration = current_duration.to_f
    progress_class = 'progress-info'
    if current_duration > 0
      max_duration = max_duration.to_f
      progress = current_duration / max_duration * 100
      #设置不同百分比显示不同的进度条颜色
      if progress >= 50 && progress < 80
        progress_class = 'progress-warning'
      elsif progress >= 80
        progress_class = 'progress-danger'
      end

      progress = "#{progress.round(2)}%"
    else
      progress = "0.00%"
    end
    current_max_str = "#{current_duration.to_i}/#{max_duration.to_i}"
    html = "<label style='float: left;'>#{progress}(#{current_max_str})</label>"
    html += "<div class='progress #{progress_class} progress-striped'>"
    html += "<div class='bar' style='width: #{progress}' title='#{progress}'></div>"
    html += '</div>'

    html.html_safe
  end

  
end
