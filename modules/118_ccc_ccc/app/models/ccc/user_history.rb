class Ccc::UserHistory < ActiveRecord::Base
  set_table_name :ccc_user_histories

  query_extend
  acts_as_customizable

  validates_presence_of :login_person_id,:end_user_name
end
