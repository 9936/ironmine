class Irm::OauthAccessClient < ActiveRecord::Base
  set_table_name :irm_oauth_access_clients
  #验证权限编码唯一性
  validates_presence_of :code, :site_url,:callback_url,:name
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| !i.code.blank? } ,:message=>:error_value_existed
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?},:message=>:code

  before_create :random_token, :random_secret
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  class << self

    # Filter to the client id(internal identifier) and the redirect uri
    def where_url(client_id, redirect_url)
      where(id: client_id,callback_url: redirect_url)
    end

    # Filter to the client secret and tclient id
    def where_secret(client_id, secret)
      where(secret: secret, id: client_id)
    end
  end

  #随机生成一个32位的token
  def random_token
    self.token = ActiveSupport::SecureRandom.hex(32)
  end

  #随机生成一个32位的secret
  def random_secret
    self.secret = ActiveSupport::SecureRandom.hex(32)
  end



end
