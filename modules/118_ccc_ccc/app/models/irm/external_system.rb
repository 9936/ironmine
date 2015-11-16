class Irm::ExternalSystem < ActiveRecord::Base
  set_table_name :irm_external_systems

  has_many :external_systems_tls, :class_name =>"Irm::ExternalSystemsTl",:foreign_key=>"external_system_id"
  attr_accessor :system_name, :system_description

  belongs_to :project_type
  belongs_to :price_type

  acts_as_multilingual({:columns =>[:system_name,:system_description],:required=>[:system_name]})


  #加入activerecord的通用方法和scope

  #validate :ip_valid, :if=> Proc.new{|i| i.external_ip_address.present?}
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_uniqueness_of :external_system_code,:scope=>[:opu_id]
  validates_presence_of :external_system_code #, :external_hostname

  scope :with_person, lambda{|person_id|
    joins(",#{Irm::ExternalSystemPerson.table_name} esp").
    where("esp.person_id = ?", person_id).
    where("esp.external_system_id = #{table_name}.id")
  }

  scope :without_person, lambda{|person_id|
    where("NOT EXISTS(SELECT * FROM #{Irm::ExternalSystemPerson.table_name} esp WHERE esp.person_id = ? AND esp.external_system_id = #{table_name}.id)", person_id)
  }

  def wrap_system_name
    self[:system_name]
  end

  def owned_people
    Irm::Person.with_external_system(self.id)
  end

  def check_ip?
    (self.external_ip_address =~ /^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/) != nil
  end

  def self.current_system=(system)
    @current_system = system
  end

  def self.current_system
    @current_system ||= Irm::Person.current.external_systems.first
  end

  private

  def ip_valid
    self.errors[:external_ip_address] << I18n.t(:error_irm_external_system_ip_invalid) unless self.check_ip?
  end
end
