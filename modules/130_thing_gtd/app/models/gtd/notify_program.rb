class Gtd::NotifyProgram < ActiveRecord::Base
  set_table_name :gtd_notify_programs

  #多语言关系
  attr_accessor :name,:description, :urgence_id, :impact_range_id
  has_many :notify_programs_tls, :dependent => :destroy

  validates_presence_of :notify_type

  validates_presence_of :urgence_id,:impact_range_id, :if => Proc.new { |i| i.notify_type == 'INCIDENT' }
  validates_presence_of :wf_mail_alert_id, :if => Proc.new { |i| i.notify_type == 'EMAIL' }

  before_save :init_notify_program
  after_find :set_notify_program

  acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_all, lambda {
    select("#{table_name}.*")
  }

  scope :with_mail_alert, lambda {
    joins("JOIN #{Irm::WfMailAlert.table_name} ma ON #{table_name}.wf_mail_alert_id=ma.id").
        select("ma.name mail_alert_name")
  }

  # 查询出紧急度
  scope :with_urgence,lambda{|urence_id|
    joins("LEFT OUTER JOIN #{Icm::UrgenceCode.view_name} urgence_code ON  urgence_code.id = #{table_name}.urgence_id AND urgence_code.language= '#{I18n.locale}'").
        select(" urgence_code.name urgence_name")
  }
  # 查询出影响度
  scope :with_impact_range,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::ImpactRange.view_name} impact_range ON  impact_range.id = #{table_name}.impact_range_id AND impact_range.language= '#{I18n.locale}'").
        select(" impact_range.name impact_range_name")
  }

  def init_notify_program
    if self.notify_type.eql?("INCIDENT")
      self.incident_request_hash = {:urgence_id =>  self.urgence_id, :impact_range_id => self.impact_range_id}.to_s
      self.wf_mail_alert_id = nil
    else
      self.incident_request_hash = nil
    end
  end

  def set_notify_program
    if self.notify_type.eql?("INCIDENT") and self.incident_request_hash.present?
      request_hash = eval(self.incident_request_hash)
      self.urgence_id = request_hash[:urgence_id]
      self.impact_range_id = request_hash[:impact_range_id]
    end
  end

end
