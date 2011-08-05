class Irm::Tab < ActiveRecord::Base
  set_table_name :irm_tabs

  validates_presence_of :function_group_id


  #多语言关系
  attr_accessor :name,:description
  has_many :tabs_tls,:dependent => :destroy
  acts_as_multilingual


  has_many :application_tabs,:dependent => :destroy

  query_extend

  scope :with_bo,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::BusinessObject.view_name} ON #{Irm::BusinessObject.view_name}.id = #{table_name}.business_object_id and #{Irm::BusinessObject.view_name}.language='#{language}'").
    select("#{Irm::BusinessObject.view_name}.name business_object_name")
  }

  scope :with_function_group,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::FunctionGroup.view_name} ON #{Irm::FunctionGroup.view_name}.id = #{table_name}.function_group_id and #{Irm::FunctionGroup.view_name}.language='#{language}'").
    select("#{Irm::FunctionGroup.view_name}.name function_group_name")
  }
end
