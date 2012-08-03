class Irm::OauthToken < ActiveRecord::Base
  set_table_name :irm_oauth_tokens


  before_create :random_token
  before_create :random_refresh_token
  before_create :create_expiration

  validates :client_id, presence: true
  validates :user_id, presence: true

  scope :get_owned_client, lambda {
    joins("JOIN #{Irm::OauthAccessClient.table_name} ON #{Irm::OauthAccessClient.table_name}.id=#{table_name}.client_id").
        select("#{Irm::OauthAccessClient.table_name}.name, #{table_name}.id").
        where("user_id=?", Irm::Person.current.id)
  }
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