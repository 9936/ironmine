class Irm::DataShareRule < ActiveRecord::Base
  set_table_name :irm_data_share_rules
   #多语言关系
  attr_accessor :name, :description
  has_many   :data_share_rules_tls,:dependent => :destroy
  acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
  validates_presence_of :code ,:business_object_id,:rule_type,:source_type,:source_id,:target_type,:target_id,:access_level
  scope :with_business_object,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::BusinessObject.view_name} ON #{table_name}.business_object_id = #{Irm::BusinessObject.view_name}.id AND #{Irm::BusinessObject.view_name}.language = '#{language}'").
        select("#{Irm::BusinessObject.view_name}.name business_object_name")
  }
  scope :with_access_level,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} access_level ON access_level.lookup_type='IRM_DATA_ACCESS_LEVEL' AND access_level.lookup_code = #{table_name}.access_level AND access_level.language= '#{language}'").
    select(" access_level.meaning access_level_name")
  }


  def self.list_all(business_object_id)
    share_rules=self.with_business_object(I18n.locale).with_access_level(I18n.locale).where("#{Irm::BusinessObject.view_name}.data_access_flag=? and #{table_name}.business_object_id=?",Irm::Constant::SYS_YES,business_object_id).
                select("#{table_name}.*")

  end
end
