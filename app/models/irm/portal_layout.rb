# -*- coding: utf-8 -*-
class Irm::PortalLayout < ActiveRecord::Base
  set_table_name :irm_port_layouts
  after_save :process_default ,:process_comma
  #多语言关系
  attr_accessor :name, :description
  has_many   :portal_layouts_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of  :layout ,:default_flag

  validates_uniqueness_of :layout,:scope=>[:opu_id], :if => Proc.new { |i| !i.layout.blank? }
  validates_format_of :layout, :with => /^[12]([,，][12])*$/ ,:if=>Proc.new{|i| !i.layout.blank?},:message=>:label_irm_portal_layout_format_error

   #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  private
  def process_default
    return true unless self.default_flag.eql?(Irm::Constant::SYS_YES)
    self.class.where("default_flag = ? AND id != ?", Irm::Constant::SYS_YES,self.id).update_all(:default_flag=>Irm::Constant::SYS_NO)
  end
  private
  def process_comma
    return true unless self.layout.count("，") > 0
    self.class.where("id = ?", self.id).update_all(:layout=>self.layout.gsub(/，/,','))
  end
end
