class Irm::OperationUnit < ActiveRecord::Base
  set_table_name :irm_operation_units

  after_create  :setup_opu_id

  #多语言关系
  attr_accessor :name,:description
  has_many :operation_units_tls,:dependent => :destroy
  acts_as_multilingual


  # 查询语言
  scope :with_default_zone,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} time_zone ON time_zone.lookup_type='TIMEZONE' AND time_zone.lookup_code = #{table_name}.default_time_zone_code AND time_zone.language= '#{language}'").
    select(" time_zone.meaning default_time_zone_name")
  }

  scope :with_language,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Language.view_name} ON #{Irm::Language.view_name}.language_code=#{table_name}.default_language_code AND #{Irm::Language.view_name}.language = '#{language}'").
    select("#{Irm::Language.view_name}.description default_language_name")
  }

  def setup_opu_id
    self.opu_id = self.id
    self.save
  end


  def self.current
    @current||self.first
  end

  def self.current=(opu)
    @current = opu
  end
end
