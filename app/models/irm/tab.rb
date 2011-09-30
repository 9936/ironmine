class Irm::Tab < ActiveRecord::Base
  set_table_name :irm_tabs

  validates_presence_of :function_group_id


  #多语言关系
  attr_accessor :name,:description
  has_many :tabs_tls,:dependent => :destroy
  acts_as_multilingual


  has_many :application_tabs,:dependent => :destroy

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_bo,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::BusinessObject.view_name} ON #{Irm::BusinessObject.view_name}.id = #{table_name}.business_object_id and #{Irm::BusinessObject.view_name}.language='#{language}'").
    select("#{Irm::BusinessObject.view_name}.name business_object_name")
  }

  scope :with_function_group,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::FunctionGroup.view_name} ON #{Irm::FunctionGroup.view_name}.id = #{table_name}.function_group_id and #{Irm::FunctionGroup.view_name}.language='#{language}'").
    select("#{Irm::FunctionGroup.view_name}.name function_group_name,#{Irm::FunctionGroup.view_name}.controller,#{Irm::FunctionGroup.view_name}.action")
  }

  scope :query_by_application,lambda{|application_id|
    joins("JOIN #{Irm::ApplicationTab.table_name} ON #{Irm::ApplicationTab.table_name}.tab_id = #{table_name}.id").
    where("#{Irm::ApplicationTab.table_name}.application_id = ?",application_id).
    order("#{Irm::ApplicationTab.table_name}.seq_num")
  }
end
