class Irm::OauthAccessClient < ActiveRecord::Base
  set_table_name :irm_oauth_access_clients
   # 验证权限编码唯一性
  validates_presence_of :code
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| !i.code.blank? } ,:message=>:error_value_existed
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?},:message=>:code

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end
