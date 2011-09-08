class Icm::IncidentStatus < ActiveRecord::Base
  set_table_name :icm_incident_statuses

  after_save :process_default

  #多语言关系
  attr_accessor :name,:description
  has_many :incident_statuses_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :incident_status_code,:phase_code
  validates_uniqueness_of :incident_status_code,:scope=>[:opu_id], :if => Proc.new { |i| !i.incident_status_code.blank? }
  validates_format_of :incident_status_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.incident_status_code.blank?}

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu


  # 对运维中心数据进行隔离
  default_scope current_opu



  scope :with_phase,lambda{
    joins("JOIN #{Icm::IncidentPhase.view_name} ON #{Icm::IncidentPhase.view_name}.phase_code = #{table_name}.phase_code AND #{Icm::IncidentPhase.view_name}.language = #{Icm::IncidentStatusesTl.table_name}.language").
    select("#{Icm::IncidentPhase.view_name}.name phase_name")

  }

  scope :query_by_close_flag,lambda{|flag|
    where("#{table_name}.close_flag = ?" ,flag)
  }

  scope :query_by_default_flag,lambda{|flag|
    where("#{table_name}.default_flag = ?" ,flag)
  }


  def self.transform(from_status_id,event)
    transform = Icm::StatusTransform.target(from_status_id,event).first
    if transform
      return transform.to_status_id
    else
      return from_status_id
    end
  end

  def self.default_id
    default = self.where(:default_flag=>Irm::Constant::SYS_YES).first
    if default
      return default.id
    else
      default = self.all.first
      if default
        return default.id
      end
      return nil
    end
  end

  private
  def process_default
    return true unless self.default_flag.eql?(Irm::Constant::SYS_YES)
    self.class.where("default_flag = ? AND id != ?", Irm::Constant::SYS_YES,self.id).update_all(:default_flag=>Irm::Constant::SYS_NO)
  end
end
