class Slm::SlaInstanceTrigger < ActiveRecord::Base
  set_table_name :slm_sla_instance_triggers

  belongs_to :sla_instance


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  after_create :generate_job

  def generate_job
    Delayed::Job.enqueue(Slm::Jobs::ServiceAgreementTriggerJob.new({:sla_instance_trigger_id=>self.id}))
  end
end