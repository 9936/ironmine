class Cons::Connect < ActiveRecord::Base

  set_table_name :cons_connects

  query_extend
  acts_as_customizable

  scope :with_connect_message,lambda{

                             }

end
