class Slm::SlaInstance < ActiveRecord::Base
  set_table_name :slm_sla_instances


  belongs_to :service_agreement

  has_many :sla_instance_triggers

  has_many :sla_instance_phases

  attr_accessor :display_color

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :with_current_status,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} current_status ON current_status.lookup_type='SLM_SLA_STATUS' AND current_status.lookup_code = #{table_name}.current_status AND current_status.language= '#{language}'").
    select(" current_status.meaning current_status_name")
  }

  scope :with_service_agreement,lambda{|language|
    joins("LEFT OUTER JOIN #{Slm::ServiceAgreement.view_name} service_agreement ON  service_agreement.id = #{table_name}.service_agreement_id AND service_agreement.language= '#{language}'").
    select(" service_agreement.name service_agreement_name")
  }

  scope :with_detail,lambda{|language|
    select("#{table_name}.*").with_current_status(language).with_service_agreement(language).order(" #{table_name}.created_by desc")
  }

  def self.start(sa, options={})
    instance = self.new(options.merge({:start_at => Time.now, :max_duration => sa.duration, :current_duration => 0, :current_status => "START"}))
    instance.start
  end

  def real_service_agreement
    if self.service_agreement
      return self.service_agreement
    else
      return Slm::ServiceAgreement.find(self.service_agreement_id)
    end
  end

  def start
    if !self.last_phase_start_date.present?
      self.calculate_phase(self.real_service_agreement, "START")
      self.sync_triggers(self.real_service_agreement, "START")
    end
    self.save
    self
  end

  def pause
    if "START".eql?(self.last_phase_type)
      self.calculate_phase(self.real_service_agreement, "PAUSE")
      self.sync_triggers(self.real_service_agreement, "PAUSE")
    end
    self.save
    self
  end

  def restart
    if "PAUSE".eql?(self.last_phase_type)
      self.calculate_phase(self.real_service_agreement, "RESTART")
      self.sync_triggers(self.real_service_agreement, "RESTART")
    end
    self.save
    self
  end

  def stop
    if ["START","PAUSE"].include?(self.last_phase_type)
      self.calculate_phase(self.real_service_agreement, "STOP")
      self.sync_triggers(self.real_service_agreement, "STOP")
    end
    self.save
    self
  end

  def cancel
    if ["START","PAUSE"].include?(self.last_phase_type)
      self.calculate_phase(self.real_service_agreement, "CANCEL")
      self.sync_triggers(self.real_service_agreement, "CANCEL")
    end
    self.save
    self
  end

  #生成新的计时阶段
  def calculate_phase(sa, action)
    if action.eql?("START")
      new_sip = self.sla_instance_phases.build(:start_at => Time.now, :phase_type => "START", :duration => 0)
      self.last_phase_start_date = new_sip.start_at
      self.last_phase_type = "START"
      self.current_status = "START"
    elsif action.eql?("PAUSE")
      sip =  self.sla_instance_phases.detect{|i| !i.end_at.present?&&i.phase_type.eql?("START")}
      return unless sip.present?
      sip.end_at = Time.now
      sip.duration = self.working_time(sa,sip.start_at, sip.end_at)
      self.current_duration = self.current_duration+sip.duration
      new_sip = self.sla_instance_phases.build(:start_at => Time.now, :phase_type => "PAUSE", :duration => 0)
      self.last_phase_start_date = new_sip.start_at
      self.last_phase_type = "PAUSE"
      self.current_status = "PAUSE"
      sip.save

    elsif action.eql?("RESTART")
      sip =  self.sla_instance_phases.detect{|i| !i.end_at.present?&&i.phase_type.eql?("PAUSE")}
      return unless sip.present?
      sip.end_at = Time.now
      sip.duration = self.working_time(sa,sip.start_at, sip.end_at)
      new_sip = self.sla_instance_phases.build(:start_at => Time.now, :phase_type => "START", :duration => 0)
      self.last_phase_start_date = new_sip.start_at
      self.last_phase_type = "START"
      self.current_status = "START"
      sip.save
    elsif action.eql?("STOP")
      sip =  self.sla_instance_phases.detect{|i| !i.end_at.present?}
      return unless sip.present?
      sip.end_at = Time.now
      sip.duration = self.working_time(sa,sip.start_at, sip.end_at)
      if sip.phase_type.eql?("START")
        self.current_duration = self.current_duration+sip.duration
      end
      self.last_phase_start_date = nil
      self.last_phase_type = nil
      self.current_status = "STOP"
      self.end_at = sip.end_at
      sip.save

    elsif action.eql?("CANCEL")
        sip =  self.sla_instance_phases.detect{|i| !i.end_at.present?}
        return unless sip.present?
        sip.end_at = Time.now
        sip.duration = self.working_time(sa,sip.start_at, sip.end_at)
        if sip.phase_type.eql?("START")
          self.current_duration = self.current_duration+sip.duration
        end
        self.last_phase_start_date = nil
        self.last_phase_type = nil
        self.current_status = "CANCEL"
        self.end_at = sip.end_at
        sip.save
    end
  end

  # 生成时间触发器
  def sync_triggers(sa, action)
    if action.eql?("START")
      sa.time_triggers.each do |tt|
        self.sla_instance_triggers.build(:time_trigger_id => tt.id, :trigger_date => self.next_working_time(sa,self.start_at, sa.duration.to_i*tt.duration_percent.to_i/100))
      end
    elsif action.eql?("PAUSE")
      self.sla_instance_triggers.each { |i| i.destroy }
    elsif action.eql?("RESTART")
      sa.time_triggers.each do |tt|
        # 如果已经过了时间则没必要生成trigger
        next if sa.duration.to_i*tt.duration_percent.to_i/100<=self.current_duration
        self.sla_instance_triggers.build(:time_trigger_id => tt.id, :trigger_date => self.next_working_time(sa,self.start_at, sa.duration.to_i*tt.duration_percent.to_i/100-self.current_duration.to_i))
      end
    elsif action.eql?("STOP")
      self.sla_instance_triggers.each { |i| i.destroy }
    elsif action.eql?("CANCEL")
      self.sla_instance_triggers.each { |i| i.destroy }
    end
  end

  def working_time(sa,start_time,end_time)
    calendar = sa.calendar
    time_zone = sa.time_zone
    if time_zone.present?
      return calendar.working_time_with_zone(time_zone,start_time,end_time)
    else
      return calendar.working_time(start_time,end_time)
    end

  end

  def next_working_time(sa,time,duration)
    calendar = sa.calendar
    time_zone = sa.time_zone
    if time_zone.present?
      return calendar.next_working_time_with_zone(time_zone,time,duration)
    else
      return calendar.next_working_time(time,duration)
    end
  end

end