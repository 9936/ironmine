class Irm::FlexValue < ActiveRecord::Base
  set_table_name :irm_flex_values

  #多语言关系
  attr_accessor :flex_value_meaning,:description
  has_many :flex_values_tls,:dependent => :destroy
  acts_as_multilingual({:columns => [:flex_value_meaning, :description],:required=>[:flex_value_meaning]})

  belongs_to :flex_value_set,:foreign_key=>"flex_value_set_id",:primary_key => "id"
  
  # 验证权限编码唯一性
  validates_presence_of :flex_value

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_by_value_set_name,lambda{|flex_value_set_name|
    select("#{table_name}.*").
    joins(",#{Irm::FlexValueSet.table_name}").
    where("#{Irm::FlexValueSet.table_name}.id = #{table_name}.flex_value_set_id").
    where("#{Irm::FlexValueSet.table_name}.flex_value_set_name = ?", flex_value_set_name)}
  
  scope :query_by_id, lambda{|id| where(:id => id)}
end


