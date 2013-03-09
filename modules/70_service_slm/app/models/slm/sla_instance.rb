class Slm::SlaInstance < ActiveRecord::Base
  set_table_name :slm_sla_instances


  belongs_to :serveice_agreement

  has_many :sla_instance_triggers

  has_many :sla_instance_phases

  belongs_to :calendar


  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  def self.start(sa, options={})
    instance = self.build(options.merge({:start_at => Time.now, :max_duration => sa.duration, :current_duration => 0, :current_status => "START"}))
    instance.start
  end

  def start
    self.calculate_phase(self.serveice_agreement, "START")
    self.sync_triggers(self.serveice_agreement, "START")
    self.save
    self
  end

  def pause
    self.calculate_phase(self.serveice_agreement, "START")
    self.sync_triggers(self.serveice_agreement, "START")
    self.save
    self
  end

  def restart
    self.calculate_phase(self.serveice_agreement, "RESTART")
    self.sync_triggers(self.serveice_agreement, "RESTART")
    self.save
    self
  end

  def stop
    self.calculate_phase(self.serveice_agreement, "STOP")
    self.sync_triggers(self.serveice_agreement, "STOP")
    self.save
    self
  end

  def cancel
    self.calculate_phase(self.serveice_agreement, "CANCEL")
    self.sync_triggers(self.serveice_agreement, "CANCEL")
    self.save
    self
  end

  #生成新的计时阶段
  def calculate_phase(sa, action)
    if action.eql?("START")
      new_sip = self.sla_instance_phases.build(:start_at => Time.now, :phase_type => "START", :duration => 0)
      self.last_phase_start_date = new_sip.start_at
      self.last_phase_type = "START"
    elsif action.eql?("PAUSE")
      self.sla_instance_phases.each do |sip|
        if !sip.end_at.present?&&sip.phase_type.eql?("START")
          sip.end_at = Time.now
          sip.duration = sa.calendar.working_time(sip.start_at, sip.end_at)
          self.duration = self.duration+sip.duration
          new_sip = self.sla_instance_phases.build(:start => Time.now, :phase_type => "PAUSE", :duration => 0)
          self.last_phase_start_date = new_sip.start_at
          self.last_phase_type = "PAUSE"
        end
      end
    elsif action.eql?("RESTART")
      self.sla_instance_phases.each do |sip|
        if !sip.end_at.present?&&sip.phase_type.eql?("PAUSE")
          sip.end_at = Time.now
          sip.duration = sa.calendar.working_time(sip.start_at, sip.end_at)

          new_sip = self.sla_instance_phases.build(:start_at => Time.now, :phase_type => "START", :duration => 0)
          self.last_phase_start_date = new_sip.start_at
          self.last_phase_type = "START"
        end
      end
    elsif action.eql?("STOP")
      self.sla_instance_phases.each do |sip|
        if !sip.end_at.present?
          sip.end_at = Time.now
          sip.duration = sa.calendar.working_time(sip.start_at, sip.end_at)
          if sip.phase_type.eql?("START")
            self.duration = self.duration+sip.duration
          end
          self.last_phase_start_date = nil
          self.last_phase_type = nil
        end
      end
    end
  end

  # 生成时间触发器
  def sync_triggers(sa, action)
    if action.eql?("START")
      sa.time_triggers.each do |tt|
        self.sla_instance_triggers.build(:time_trigger_id => tt.id, :trigger_date => sa.calendar.next_working_time(self.start_at, sa.duration*tt.duration_percent/100))
      end
    elsif action.eql?("PAUSE")
      self.sla_instance_triggers.each { |i| i.destroy }
    elsif action.eql?("RESTART")
      sa.time_triggers.each do |tt|
        # 如果已经过了时间则没必要生成trigger
        next if sa.duration*tt.duration_percent/100<=self.current_duration
        self.sla_instance_triggers.build(:time_trigger_id => tt.id, :trigger_date => sa.calendar.next_working_time(self.start_at, sa.duration*tt.duration_percent/100-self.current_duration))
      end
    elsif action.eql?("STOP")
      self.sla_instance_triggers.each { |i| i.destroy }
    end
  end
end