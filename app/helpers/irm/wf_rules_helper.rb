module Irm::WfRulesHelper
  def available_evaluate_criteria_rules
    Irm::LookupValue.query_by_lookup_type("WORKFLOW_RULE_EVALUATE_TYPE").multilingual.order_id.collect{|p|[p[:meaning],p[:lookup_code]]}
  end


  def available_workflow_business_object
    Irm::BusinessObject.enabled.multilingual.where(:workflow_flag=>Irm::Constant::SYS_YES).collect{|i|[i[:name],i.business_object_code,{:bo_table_name=>i.bo_table_name}]}
  end

  def wf_rule_immediate_actions(wf_rule_id)
    wf_rule_actions = Irm::WfRuleAction.where(:rule_id=>wf_rule_id,:time_trigger_id=>nil)
    actions = []
    wf_rule_actions.each do |action|
      ref_action =  action.action_type.constantize.query(action.action_reference_id).first
      next unless ref_action
      case action.action_type
        when Irm::WfMailAlert.name
          ref_action_options = {:action_type_name=>t("label_"+Irm::WfMailAlert.name.underscore.gsub("\/","_")),
                                :edit_url_options=>{:controller=>"irm/wf_mail_alerts",:action=>"edit",:id=>action.action_reference_id},
                                :show_url_options=>{:controller=>"irm/wf_mail_alerts",:action=>"show",:id=>action.action_reference_id},
                                :ref_action=>ref_action,:action=>action}
        when Irm::WfFieldUpdate.name
          ref_action_options = {:action_type_name=>t("label_"+Irm::WfFieldUpdate.name.underscore.gsub("\/","_")),
                                :edit_url_options=>{:controller=>"irm/wf_field_updates",:action=>"edit",:id=>action.action_reference_id},
                                :show_url_options=>{:controller=>"irm/wf_field_updates",:action=>"show",:id=>action.action_reference_id},
                                :ref_action=>ref_action,:action=>action}
      end
      actions << ref_action_options
    end
    actions
  end


  def wf_rule_time_triggers(wf_rule_id)
    Irm::WfRuleTimeTrigger.list_all.where(:rule_id=>wf_rule_id)
  end

  def wf_rule_time_trigger_actions(wf_rule_id,time_trigger_id)
    wf_rule_actions = Irm::WfRuleAction.where(:rule_id=>wf_rule_id,:time_trigger_id=>time_trigger_id)
    actions = []
    wf_rule_actions.each do |action|
      ref_action =  action.action_type.constantize.query(action.action_reference_id).first
      next unless ref_action
      case action.action_type
        when Irm::WfMailAlert.name
          ref_action_options = {:action_type_name=>t("label_"+Irm::WfMailAlert.name.underscore.gsub("\/","_")),
                                :edit_url_options=>{:controller=>"irm/wf_mail_alerts",:action=>"edit",:id=>action.action_reference_id},
                                :show_url_options=>{:controller=>"irm/wf_mail_alerts",:action=>"show",:id=>action.action_reference_id},
                                :ref_action=>ref_action,:action=>action}
        when Irm::WfFieldUpdate.name
          ref_action_options = {:action_type_name=>t("label_"+Irm::WfFieldUpdate.name.underscore.gsub("\/","_")),
                                :edit_url_options=>{:controller=>"irm/wf_field_updates",:action=>"edit",:id=>action.action_reference_id},
                                :show_url_options=>{:controller=>"irm/wf_field_updates",:action=>"show",:id=>action.action_reference_id},
                                :ref_action=>ref_action,:action=>action}
      end
      actions << ref_action_options
    end
    actions
  end

  def wf_rule_exists_actions(wf_rule_id)
    values = []
    bo_code = Irm::WfRule.find(wf_rule_id).bo_code

    label_name =Irm::BusinessObject.class_name_to_meaning(Irm::WfFieldUpdate.name)
    code = Irm::BusinessObject.class_name_to_code(Irm::WfFieldUpdate.name)
    values +=Irm::WfFieldUpdate.where(:bo_code=>bo_code).collect{|i| ["#{label_name}:#{i.name}","#{code}##{i.id}",{:type=>code,:query=>i.name}]}

    label_name =Irm::BusinessObject.class_name_to_meaning(Irm::WfMailAlert.name)
    code = Irm::BusinessObject.class_name_to_code(Irm::WfMailAlert.name)
    values +=Irm::WfMailAlert.where(:bo_code=>bo_code).collect{|i| ["#{label_name}:#{i.name}","#{code}##{i.id}",{:type=>code,:query=>i.name}]}

    values
  end

  def wf_rule_belongs_actions(wf_rule_id,time_trigger_id=nil)
    action_types = [[Irm::WfFieldUpdate,Irm::BusinessObject.class_name_to_code(Irm::WfFieldUpdate.name)],[Irm::WfMailAlert,Irm::BusinessObject.class_name_to_code(Irm::WfMailAlert.name)]]
    wf_rule_actions = Irm::WfRuleAction.where(:rule_id=>wf_rule_id,:time_trigger_id=>time_trigger_id)
    actions = []
    wf_rule_actions.each do |action|
      action_type = action_types.detect{|i| i[0].name.eql?(action.action_type)}
      actions<<"#{action_type[1]}##{action.action_reference_id}"
    end
    actions.join(",")
  end
end
