class Slm::SlaInstance < ActiveRecord::Base
  set_table_name :slm_sla_instances


  belongs_to :serveice_agreement

  has_many :sla_instance_triggers

  has_many :sla_instance_phases



  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def self.prepare(sa,options={})
    instance = self.build(options.merge({:start_at=>Time.now,:max_duration=>sa.duration,:current_duration=>0,:current_status=>"START",:last_phase_type=>"START",:last_phase_start_date=>Time.now}))
    instance.sla_instance_phases.build(:start=>Time.now,:phase_type=>"START",:duration=>0)
    instance.sync_triggers(sa)
  end

  def pause

  end

  def start

  end

  def stop

  end

  def cancel

  end

  def sync_triggers

  end
end