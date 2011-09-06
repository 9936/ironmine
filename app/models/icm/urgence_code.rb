class Icm::UrgenceCode < ActiveRecord::Base
  set_table_name :icm_urgence_codes
  after_save :process_default,:process_weight_value

  attr_accessor :not_process_after_save
  #多语言关系
  attr_accessor :name,:description
  has_many :urgence_codes_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :urgency_code,:weight_values,:display_sequence
  validates_uniqueness_of :urgency_code,:scope=>[:opu_id], :if => Proc.new { |i| !i.urgency_code.blank? }
  validates_format_of :urgency_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.urgency_code.blank?}

  #加入activerecord的通用方法和scope
  query_extend


  def self.default_id
    default = self.where(:default_flag=>Irm::Constant::SYS_YES).first
    if default
      return default.id
    else
      return nil
    end
  end

  private
  def process_default
    return true if self.default_flag.eql?(Irm::Constant::SYS_NO)||not_process_after_save
    self.class.where("default_flag = ? AND id != ?", Irm::Constant::SYS_YES,self.id).update_all(:default_flag=>Irm::Constant::SYS_NO)
  end

  def process_weight_value
    return true if not_process_after_save
    self.class.enabled.order("display_sequence DESC").each_with_index do |u,index|
      u.update_attributes(:weight_values=>index+1,:not_process_after_save=>true,:not_auto_mult=>true)
    end
    Icm::PriorityCode.auto_generate
  end
end