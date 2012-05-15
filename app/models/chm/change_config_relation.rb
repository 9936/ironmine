class Chm::ChangeConfigRelation < ActiveRecord::Base
  set_table_name :chm_change_config_relations

  belongs_to :change_request
  belongs_to :config_item,:class_name => "Com::ConfigItem"

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_uniqueness_of :change_request_id,:scope => [:config_item_id]

  scope :with_config_item,lambda{
    joins("JOIN #{Com::ConfigItem.table_name} ON #{Com::ConfigItem.table_name}.id = #{table_name}.config_item_id").
    joins("LEFT OUTER JOIN #{Com::ConfigClass.view_name} ON #{Com::ConfigItem.table_name}.config_class_id=#{Com::ConfigClass.view_name}.id and #{Com::ConfigClass.view_name}.language='#{I18n.locale}'").
    joins("LEFT OUTER JOIN #{Icm::SupportGroup.multilingual_view_name} ON #{Com::ConfigItem.table_name}.managed_group_id=#{Icm::SupportGroup.multilingual_view_name}.id and #{Icm::SupportGroup.multilingual_view_name}.language='#{I18n.locale}'").
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} ON #{Com::ConfigItem.table_name}.managed_person_id=#{Irm::Person.table_name}.id").
    select("#{Com::ConfigItem.table_name}.item_number,#{Com::ConfigItem.table_name}.last_checked_at,#{Com::ConfigClass.view_name}.name config_class_name,#{Icm::SupportGroup.multilingual_view_name}.name managed_group_name,#{Irm::Person.table_name}.full_name managed_person_name")
  }
end
