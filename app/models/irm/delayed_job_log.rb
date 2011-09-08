class Irm::DelayedJobLog < ActiveRecord::Base
  set_table_name :irm_delayed_job_logs
  has_many :delayed_job_log_items, :primary_key => "delayed_job_id", :foreign_key => "delayed_job_id"

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu

  scope :select_all, lambda{
    select("#{table_name}.*")
  }

  scope :with_job_status, lambda{
    select("(SELECT lvt.meaning FROM #{Irm::DelayedJobLogItem.table_name} li, #{Irm::LookupValue.table_name} lv,
            #{Irm::LookupValuesTl.table_name} lvt
            WHERE li.delayed_job_id = #{table_name}.delayed_job_id
              AND lv.lookup_type = 'IRM_DELAYED_JOB_STATUS' AND lvt.language='zh' AND lvt.lookup_value_id = lv.id AND lv.lookup_code = li.job_status
            ORDER BY li.id DESC LIMIT 1) job_status")
  }

  scope :with_incident_request, lambda{
    select("'' incident_request_number, '' incident_request_id, '' group_code, '' group_name")
  }

  scope :with_rule_action, lambda{
    select("'' action_type, '' action_name, '' action_id")
  }

  scope :with_approval_process, lambda{
    select("'' approval_process_name, '' bo_name, '' bo_description, '' approval_step_name, '' approver")
  }

  def self.list_all
    select_all.with_job_status.order("created_at DESC")
  end

  def self.wf_process_job_monitor
    monitor = Irm::DelayedJobLog.
                  where("#{Irm::DelayedJobLog.table_name}.bo_code = ?", "ICM_INCIDENT_REQUESTS").
                  group_by{|t| t.instance_id}
    monitor
  end

  def self.icm_group_assign_monitor
    monitor = Irm::DelayedJobLog.select_all.with_incident_request.with_job_status.order("#{Irm::DelayedJobLog.table_name}.created_at DESC")
    monitor_group = monitor.group_by{|t| YAML.load(t.handler).class.to_s}
    ret_logs = []
    monitor_group.each do |handler, logs|
      if handler == "Irm::Jobs::IcmGroupAssignmentJob"
        ret_logs = logs
        break
      end
    end
    ret_logs_new = []
    ret_logs.each do |t|
      incident_request = Icm::IncidentRequest.select_all.where(:id => YAML.load(t.handler).incident_request_id).with_support_group(I18n.locale).first
      incident_request_number = incident_request.request_number
      t.incident_request_number = incident_request_number
      t.incident_request_id = YAML.load(t.handler).incident_request_id
      t.group_code = incident_request[:support_group_code]
      t.group_name = incident_request[:support_group_name]

      ret_logs_new << t
    end
    ret_logs_new
  end

  def self.ir_rule_process_monitor
    monitor = Irm::DelayedJobLog.select_all.
        with_incident_request.
        with_rule_action.
        with_job_status.
        order("#{Irm::DelayedJobLog.table_name}.created_at DESC")
    monitor_group = monitor.group_by{|t| YAML.load(t.handler).class.to_s}
    ret_logs = []
    monitor_group.each do |handler, logs|
      if handler == "Irm::Jobs::ActionProcessJob"
        ret_logs = logs
        break
      end
    end
    ret_logs_new = []
    ret_logs.each do |t|
      begin
        next unless YAML.load(t.handler).options[:bo_code] == "ICM_INCIDENT_REQUESTS"
        action = eval(YAML.load(t.handler).options[:action_type]).where(:id => YAML.load(t.handler).options[:action_id]).first
        incident_request = Icm::IncidentRequest.where(:id => YAML.load(t.handler).options[:bo_id]).first
        t.incident_request_number = incident_request.request_number
        t.incident_request_id = incident_request.id
        t.action_type = Irm::BusinessObject.multilingual.where("#{Irm::BusinessObject.table_name}.bo_model_name = ?", YAML.load(t.handler).options[:action_type]).first[:name]
        t.action_name = action.name
        t.action_id = action.id

        ret_logs_new << t
      rescue
        next
      end
    end
    ret_logs_new
  end

  def self.wf_approval_mail_monitor
    monitor = Irm::DelayedJobLog.
        select_all.
        with_approval_process.
        with_job_status.
        order("#{Irm::DelayedJobLog.table_name}.created_at DESC")
    monitor_group = monitor.group_by{|t| YAML.load(t.handler).class.to_s}
    ret_logs = []
    monitor_group.each do |handler, logs|
      if handler == "Irm::Jobs::ApprovalMailJob"
        ret_logs = logs
        break
      end
    end
    ret_logs_new = []
    ret_logs.each do |t|
#      begin
        step_instance = Irm::WfStepInstance.where(:id => YAML.load(t.handler).step_instance_id).first
        approval_step = Irm::WfApprovalStep.where(:id => step_instance.step_id).first
        process_instance = Irm::WfProcessInstance.where(:id => step_instance.process_instance_id).first
        approval_process = Irm::WfApprovalProcess.where(:id => process_instance.process_id).first
        business_object = Irm::BusinessObject.multilingual.where("#{Irm::BusinessObject.table_name}.business_object_code = ?", approval_process.bo_code).first

        t.approval_process_name = approval_process.name
        t.bo_description = process_instance.bo_description
        t.approval_step_name = approval_step.name
        t.bo_name = business_object[:name]

        ret_logs_new << t
#      rescue
#        next
#      end
    end
    ret_logs_new
  end
end