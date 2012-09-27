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
  #validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present? },:message=>:code


  query_extend


  scope :query_by_system,lambda{|system_id|
    where("EXISTS (SELECT 1 FROM #{Icm::IncidentCategorySystem.table_name} WHERE #{Icm::IncidentCategorySystem.table_name}.incident_category_id = #{table_name}.id AND #{Icm::IncidentCategorySystem.table_name}.external_system_id = ?)" ,system_id)

  }

  scope :query_with_system_ids_and_self,lambda{|system_ids, self_id|
    where("EXISTS (SELECT 1 FROM  #{Icm::IncidentCategorySystem.table_name} WHERE #{Icm::IncidentCategorySystem.table_name}.incident_category_id = #{table_name}.id AND #{Icm::IncidentCategorySystem.table_name}.external_system_id IN (?) OR #{table_name}.created_by = ?)",system_ids + [''], self_id)
  }

  scope :query_with_system_name,lambda{|system_ids, self_id|
    where("EXISTS (SELECT 1 FROM  #{Icm::IncidentCategorySystem.table_name} WHERE #{Icm::IncidentCategorySystem.table_name}.incident_category_id = #{table_name}.id AND #{Icm::IncidentCategorySystem.table_name}.external_system_id IN (?) OR #{table_name}.created_by = ?)",system_ids + [''], self_id)
  }

  scope :query_with_system_ids_and_self_and_name,lambda{|system_ids, self_id, system_name|
    where(%Q(EXISTS (SELECT 1 FROM  #{Icm::IncidentCategorySystem.table_name}, #{Irm::ExternalSystemsTl.table_name}
              WHERE #{Icm::IncidentCategorySystem.table_name}.incident_category_id = #{table_name}.id
                AND (#{Icm::IncidentCategorySystem.table_name}.external_system_id IN (?) OR #{table_name}.created_by = ?)
                AND #{Irm::ExternalSystemsTl.table_name}.system_name LIKE ?
                AND #{Irm::ExternalSystemsTl.table_name}.external_system_id = #{Icm::IncidentCategorySystem.table_name}.external_system_id)),
          system_ids + [''], self_id, '%' + system_name + '%')
  }

  def self.list_all
    self.select_all.multilingual
  end


  def self.lov(origin_scope,params)
    return origin_scope.where("EXISTS(SELECT 1 FROM #{Icm::IncidentCategorySystem.table_name} system WHERE system.external_system_id in(?) AND system.incident_category_id = #{view_name}.id)",Irm::Person.current.system_ids)
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

