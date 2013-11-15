class Slm::ServiceAgreement < ActiveRecord::Base
  set_table_name :slm_service_agreements

  attr_accessor :duration_day, :duration_hour, :duration_minute

  #多语言关系
  attr_accessor :name, :description
  has_many :service_agreements_tls, :dependent => :destroy, :foreign_key => "service_agreement_id"
  acts_as_multilingual


  belongs_to :business_object, :foreign_key => :business_object_code, :primary_key => :business_object_code

  has_many :time_triggers

  belongs_to :calendar

  validates_presence_of :external_system_id, :calendar_id


  before_validation :transform_time
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :with_calendar, lambda {|language|
    joins("JOIN #{Slm::CalendarsTl.table_name} ON #{Slm::CalendarsTl.table_name}.calendar_id = #{table_name}.calendar_id").
        where("#{Slm::CalendarsTl.table_name}.language = ?", language).
        select("#{Slm::CalendarsTl.table_name}.name calendar_name")
  }

  scope :with_system, lambda {|external_system_id|
    where("#{table_name}.external_system_id=?", external_system_id)
  }

  #根据天，小时还有秒来区分
  def transform_time
    self.duration = self.duration_day.to_i * 1440 + self.duration_hour.to_i * 60 + self.duration_minute.to_i
  end

  def untransform_time
    self.duration ||= 0
    self.duration = self.duration.to_i
    self.duration ||= self.duration.to_i
    self.duration_day ||= self.duration/1440
    self.duration_hour ||= (self.duration%1440)/60
    self.duration_minute ||= self.duration%60
  end

  def duration_meaning
    untransform_time
    "#{self.duration_day} #{I18n.t(:label_slm_service_agreement_duration_day)}
    #{ self.duration_hour}#{I18n.t(:label_slm_service_agreement_duration_hour) }
    #{self.duration_minute}#{I18n.t(:label_slm_service_agreement_duration_minute)}"
  end


  def match_start(event)
    rule_filter = self.start_filter
    business_object = rule_filter.generate_scope.where(:external_system_id => self.external_system_id, :id => event.business_object_id).first
    business_object
  end

  def match_pause(event)
    rule_filter = self.pause_filter
    business_object = rule_filter.generate_scope.where(:external_system_id => self.external_system_id, :id => event.business_object_id).first
    business_object
  end


  def match_stop(event)
    rule_filter = self.stop_filter
    business_object = rule_filter.generate_scope.where(:external_system_id => self.external_system_id, :id => event.business_object_id).first
    business_object
  end

  def match_cancel(event)
    rule_filter = self.cancel_filter
    business_object = rule_filter.generate_scope.where(:external_system_id => self.external_system_id, :id => event.business_object_id).first
    business_object
  end


  def start_filter
    if self.id.present?
      @start_filter ||=Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}St", self.id).first
    end
    @start_filter
  end

  def pause_filter
    if self.id.present?
      @pause_filter ||=Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}Pa", self.id).first
    end
    @pause_filter
  end

  def stop_filter
    if self.id.present?
      @stop_filter ||=Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}Sp", self.id).first
    end
    @stop_filter
  end

  def cancel_filter
    if self.id.present?
      @cancel_filter ||=Irm::RuleFilter.query_by_source("#{Slm::ServiceAgreement.name}Ca", self.id).first
    end
    @cancel_filter
  end


  def self.process(event,force=false)
    return unless force||!Irm::Event.where("id != ?",event.id).where(:event_code=>event.event_code,:business_object_id=>event.business_object_id,:bo_code=>event.bo_code,:end_at=>nil).first.present?
    return unless self.where(:business_object_code => event.bo_code).enabled.count>0
    bo = Irm::BusinessObject.where(:business_object_code => event.bo_code).first
    bo_instance = bo.bo_model_name.constantize.find(event.business_object_id)
    return unless bo_instance.respond_to?(:external_system_id)&&bo_instance.send(:external_system_id).present?
    service_agreements = self.where(:business_object_code => event.bo_code, :external_system_id => bo_instance.send(:external_system_id)).enabled
    if service_agreements.any?
      service_agreements.each do |sa|
        #处理符合开始条件的
        sla_instance = Slm::SlaInstance.where(:bo_type => bo_instance.class.name, :bo_id => bo_instance.id, :service_agreement_id => sa.id).detect { |slai| !slai.end_at.present? }

        if !sla_instance.present?
          start_bo_instance = sa.match_start(event)
          if start_bo_instance.present?
            sla_instance = Slm::SlaInstance.start(sa,{:bo_type => bo_instance.class.name, :bo_id => bo_instance.id, :service_agreement_id => sa.id})
          end
        end
      end
    end

    sla_instances = Slm::SlaInstance.where(:bo_type => bo_instance.class.name, :bo_id => bo_instance.id).collect { |slai| slai.end_at.present? ? nil : slai }.compact
    sla_instances.each do |slai|
      sa = slai.service_agreement
      sla_bo_instance = sa.match_cancel(event)
      if sla_bo_instance.present?
        slai.cancel
        next
      end
      sla_bo_instance = sa.match_stop(event)
      if sla_bo_instance.present?
        slai.stop
        next
      end
      sla_bo_instance = sa.match_pause(event)
      if sla_bo_instance.present?
        slai.pause
      else
        slai.restart
      end
    end
  end
end
