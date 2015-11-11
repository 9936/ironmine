class Cons::Price < ActiveRecord::Base

  set_table_name :cons_prices

  query_extend
  acts_as_customizable

  scope :with_price_message,lambda{

                             }

end
