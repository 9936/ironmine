class Com::ConfigItemRelation < ActiveRecord::Base
  set_table_name :com_config_item_relations
    #加入activerecord的通用方法和scope
    query_extend
    # 对运维中心数据进行隔离
    default_scope {default_filter}
    validates_presence_of :config_item_id,:config_relation_type_id,:relation_config_item_id
    scope :with_config_item,lambda{
      joins("LEFT OUTER JOIN #{Com::ConfigItem.table_name} cci1 ON cci1.id=#{table_name}.config_item_id").
          select("cci1.item_number item_number")
    }
    scope :with_config_relation_type,lambda{
      joins("LEFT OUTER JOIN #{Com::ConfigRelationType.view_name} ON #{Com::ConfigRelationType.view_name}.id=#{table_name}.config_relation_type_id and #{Com::ConfigRelationType.view_name}.language='#{I18n.locale}'").
          select("#{Com::ConfigRelationType.view_name}.name relation_type_name")
    }
    scope :with_relation_config_item,lambda{
      joins("LEFT OUTER JOIN #{Com::ConfigItem.table_name} cci2 ON cci2.id=#{table_name}.config_item_id").
              select("cci2.item_number relation_item_number")
    }
    scope :query_by_config_item_id,lambda{|config_item_id|
      where("#{table_name}.config_item_id=?",config_item_id)
    }
    def self.list_all
       select_all.with_config_item.with_config_relation_type.with_relation_config_item
    end
end
