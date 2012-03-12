class Irm::OauthAccessClient < ActiveRecord::Base
  set_table_name :irm_oauth_access_clients
  #验证权限编码唯一性
  validates_presence_of :code
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| !i.code.blank? } ,:message=>:error_value_existed
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?},:message=>:code

  before_create :random_token, :random_secret
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  #随机生成一个32位的token
  def random_token
    self.token = ActiveSupport::SecureRandom.hex(32)
  end

  #随机生成一个32位的secret
  def random_secret
    self.secret = ActiveSupport::SecureRandom.hex(32)
  end

end
