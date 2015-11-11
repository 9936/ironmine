class Cons::Status < ActiveRecord::Base

  set_table_name :cons_statuses

  query_extend
  acts_as_customizable

  scope :with_status_message,lambda{

                             }

end
