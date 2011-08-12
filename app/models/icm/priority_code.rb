class Icm::PriorityCode < ActiveRecord::Base
  set_table_name :icm_priority_codes

  #多语言关系
  attr_accessor :name,:description
  has_many :priority_codes_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :priority_code,:weight_values
  validates_uniqueness_of :priority_code, :if => Proc.new { |i| !i.priority_code.blank? }
  validates_format_of :priority_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.priority_code.blank?}

  #加入activerecord的通用方法和scope
  query_extend


  scope :with_company,lambda{
    joins("LEFT OUTER JOIN #{Irm::Company.view_name} ON #{Irm::Company.view_name}.id = #{table_name}.company_id AND #{Icm::PriorityCodesTl.table_name}.language = #{Irm::Company.view_name}.language").
    select("#{Irm::Company.view_name}.name company_name")
  }

  scope :query_by_weight_value,lambda{|weight_value|
    where("#{table_name}.weight_values = ?",weight_value)
  }


  def self.auto_generate
    priority_count = Icm::ImpactRange.enabled.size+Icm::UrgenceCode.enabled.size
    max_count = Icm::ImpactRange.all.size+Icm::UrgenceCode.all.size
    self.where("weight_values>? OR weight_values<1",max_count-1).delete_all
    self.where("weight_values>?",priority_count-1).update_all(:status_code=>"OFFLINE")
    1.upto(priority_count-1).each do |i|
      unless self.where(:weight_values=>i).exists?
        self.create(:priority_code=>"GRADE_#{i}",:name=>"Grade #{i}",:description=>"Grade #{i}",:weight_values=>i)
      end
    end
  end

end
