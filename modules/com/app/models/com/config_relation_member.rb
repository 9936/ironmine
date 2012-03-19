class Com::ConfigRelationMember < ActiveRecord::Base
  set_table_name :com_config_relation_members
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
  validates_presence_of :config_relation_type_id,:config_class_id
  validates_uniqueness_of :config_class_id ,:scope => [:config_relation_type_id]

  scope :with_config_relation_type,lambda{
    joins(",#{Com::ConfigRelationType.view_name}").
        where("#{Com::ConfigRelationType.view_name}.id=#{table_name}.config_relation_type_id and #{Com::ConfigRelationType.view_name}.language=?",I18n.locale).
        select("#{Com::ConfigRelationType.view_name}.name type_name")
  }
  scope :with_config_relation_class,lambda{
    joins(",#{Com::ConfigClass.view_name}").
        where("#{Com::ConfigClass.view_name}.id=#{table_name}.config_class_id and #{Com::ConfigClass.view_name}.language=?",I18n.locale).
        select("#{Com::ConfigClass.view_name}.name config_class_name")
  }

end
