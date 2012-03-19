class Com::ConfigItemAttribute < ActiveRecord::Base
  set_table_name :com_config_item_attributes
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
  validates_presence_of :config_item_id,:config_attribute_id
  scope :query_by_config_item_id,lambda{|config_item_id|
    where("#{table_name}.config_item_id=?",config_item_id)
  }
  scope :with_attribute_name,lambda{
    joins("LEFT OUTER JOIN #{Com::ConfigAttribute.view_name} ON #{Com::ConfigAttribute.view_name}.id=#{table_name}.config_attribute_id and #{Com::ConfigAttribute.view_name}.language='#{I18n.locale}'").
        select("#{Com::ConfigAttribute.view_name}.name config_attribute_name")
  }
end
