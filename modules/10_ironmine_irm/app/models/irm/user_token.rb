class Irm::UserToken < ActiveRecord::Base
  set_table_name :irm_user_tokens

  before_create :random_token

  belongs_to :person, :class_name => "Irm::Person"

  #检查token_type 是否合法
  validates_inclusion_of :token_type ,:in => ["RESET_PWD"]



  def reset_pwd(email,person_id,url)
    Delayed::Job.enqueue(Irm::Jobs::ForgetPwdJob.new(email,person_id, url ))
  end

  def expired?
    self.created_at < 30.minutes.ago
  end

  private
    def random_token
      self.token = ActiveSupport::SecureRandom.hex(32)
    end

end
