class Irm::OauthAccess < ActiveRecord::Base
  set_table_name :irm_oauth_accesses

  before_create :init_times

  validates_presence_of :token_id, :ip_address

  def increment!
    self.times += 1
    self.save
  end

  def init_times
    self.times = 1
  end
end