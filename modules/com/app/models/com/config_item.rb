class Com::ConfigItem < ActiveRecord::Base
  set_table_name :com_config_items
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
  validates_presence_of :item_number,:config_class_id
  validates_uniqueness_of :item_number,:scope=>[:opu_id], :if => Proc.new { |i| !i.item_number.blank? }
  before_save :default_values

  def default_values
    self.last_checked_at ||= Time.now
  end

  scope :with_config_class,lambda{
    joins("LEFT OUTER JOIN #{Com::ConfigClass.view_name} ON #{table_name}.config_class_id=#{Com::ConfigClass.view_name}.id and #{Com::ConfigClass.view_name}.language='#{I18n.locale}'").
        select("#{Com::ConfigClass.view_name}.name config_class_name")
  }
  scope :with_managed_group,lambda{
    joins("LEFT OUTER JOIN #{Icm::SupportGroup.multilingual_view_name} ON #{table_name}.managed_group_id=#{Icm::SupportGroup.multilingual_view_name}.id and #{Icm::SupportGroup.multilingual_view_name}.language='#{I18n.locale}'").
        select("#{Icm::SupportGroup.multilingual_view_name}.name managed_group_name")
  }
  scope :with_managed_person,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} ON #{table_name}.managed_person_id=#{Irm::Person.table_name}.id").
        select("#{Irm::Person.table_name}.full_name managed_person_name")
  }

end
