class Irm::OauthCode < ActiveRecord::Base
  set_table_name :irm_oauth_codes

  before_create :random_code, :create_expiration

  #随机生成一个32位的code
  def random_code
    self.code = ActiveSupport::SecureRandom.hex(32)
  end
  #生成过期时间不超过150秒
  def create_expiration
    self.expire_at = Time.now + 150
  end

  #检测当前令牌是否过期
  def expired?
    self.expire_at < Time.now
  end
end