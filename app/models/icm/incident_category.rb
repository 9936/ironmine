class Icm::IncidentCategory < ActiveRecord::Base
  set_table_name :icm_incident_categories

  #多语言关系
  attr_accessor :name,:description
  has_many :incident_categories_tls,:dependent => :destroy
  acts_as_multilingual


  has_many :incident_sub_categories ,:dependent => :destroy

  attr_accessor :system_str
  has_many :incident_category_systems


  validates_presence_of :code
  validates_uniqueness_of :code, :scope=>[:opu_id],:if => Proc.new { |i| i.code.present? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present? },:message=>:code


  query_extend


  scope :query_by_system,lambda{|system_id|
    joins("JOIN #{Icm::IncidentCategorySystem.table_name} ON #{Icm::IncidentCategorySystem.table_name}.incident_category_id = #{table_name}.id").
        where("#{Icm::IncidentCategorySystem.table_name}.external_system_id = ? ",system_id)

  }


  def self.list_all
    self.select_all.multilingual
  end



  #创建 更新报表列
  def create_system_from_str
    value_str = self.system_str
    return unless value_str
    str_values = value_str.split(",").delete_if{|i| !i.present?}
    exists_values = Icm::IncidentCategorySystem.where(:incident_category_id=>self.id)
    exists_values.each do |e_value|
      if str_values.include?(e_value.external_system_id)
        str_values.delete(e_value.external_system_id)
      else
        e_value.destroy
      end

    end

    str_values.each do |value_id|
      next unless value_id.strip.present?
      self.incident_category_systems.build({:external_system_id=>value_id})
    end if str_values.any?
  end

  def get_system_str
    return @get_system_str if @get_system_str
    @get_system_str = Icm::IncidentCategorySystem.where(:incident_category_id=>self.id).collect{|value| value.external_system_id}.join(",")
  end

end

