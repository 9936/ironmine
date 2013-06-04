class Irm::OauthAccess < ActiveRecord::Base
  set_table_name :irm_oauth_accesses

  before_create :init_times

  validates_presence_of :token_id, :ip_address

  scope :query_user, lambda {|client_id|
    joins("JOIN #{Irm::OauthToken.table_name} ot ON ot.id=#{table_name}.token_id").
        joins("JOIN #{Irm::Person.table_name} p ON ot.user_id=p.id").
        where("ot.client_id=?", client_id).
        select("#{table_name}.*, p.full_name user_name")
  }

  def increment!
    self.times += 1
    self.save
  end

  def init_times
    self.times = 1
  end

end