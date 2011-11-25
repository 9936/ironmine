class Icm::IncidentCategory < ActiveRecord::Base
  set_table_name :icm_incident_categories

  #多语言关系
  attr_accessor :name,:description
  has_many :incident_categories_tls,:dependent => :destroy
  acts_as_multilingual


  has_many :incident_sub_categories ,:dependent => :destroy


  validates_presence_of :code,:external_system_id
  validates_uniqueness_of :code, :scope=>[:opu_id],:if => Proc.new { |i| i.code.present? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present? },:message=>:code


  query_extend

  scope :with_external_system, lambda{|language|
    joins("JOIN #{Irm::ExternalSystem.view_name} external_system ON external_system.id = #{table_name}.external_system_id AND external_system.language = '#{language}'").
        select("external_system.system_name external_system_name")
  }


  def self.list_all
    self.select_all.multilingual.with_external_system(I18n.locale)
  end
end
