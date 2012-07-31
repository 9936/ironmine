class Icm::IncidentSubCategory < ActiveRecord::Base
  set_table_name :icm_incident_sub_categories

  #多语言关系
  attr_accessor :name,:description
  has_many :incident_sub_categories_tls,:dependent => :destroy
  acts_as_multilingual

  belongs_to :incident_category


  validates_presence_of :code,:incident_category_id
  validates_uniqueness_of :code, :scope=>[:opu_id],:if => Proc.new { |i| i.code.present? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present? },:message=>:code

  query_extend

  scope :with_incident_category, lambda{|language|
    joins("JOIN #{Icm::IncidentCategory.view_name} ON #{Icm::IncidentCategory.view_name}.id = #{table_name}.incident_category_id AND #{Icm::IncidentCategory.view_name}.language = '#{language}'").
        select("#{Icm::IncidentCategory.view_name}.name incident_category_name")
  }

  def self.list_all
    self.select_all.multilingual.with_incident_category(I18n.locale)
  end


  def self.lov(origin_scope,params)
    return origin_scope.where("EXISTS(SELECT 1 FROM #{Icm::IncidentCategorySystem.table_name} system WHERE system.external_system_id in(?) AND system.incident_category_id = #{view_name}.incident_category_id)",Irm::Person.current.system_ids)
  end
end
