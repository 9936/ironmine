class Cons::Level < ActiveRecord::Base

  set_table_name :cons_levels

  query_extend
  acts_as_customizable

  scope :with_level_message,lambda{

                             }

end
