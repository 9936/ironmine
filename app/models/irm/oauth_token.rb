class Irm::OauthToken < ActiveRecord::Base
  set_table_name :irm_oauth_tokens


  before_create :random_token
  before_create :random_refresh_token
  before_create :create_expiration

  validates :client_id, presence: true
  validates :user_id, presence: true

  #检测当前令牌是否过期
  def expired?
    self.expire_at < Time.now
  end

  private
    def random_token
      self.token = ActiveSupport::SecureRandom.hex(32)
    end

    def random_refresh_token
      self.refresh_token = ActiveSupport::SecureRandom.hex(32)
    end

    #定义token 过期在1800秒内
    def create_expiration
      self.expire_at = Time.now + 1800
    end
end