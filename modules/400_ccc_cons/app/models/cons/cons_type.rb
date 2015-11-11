class Cons::ConsType < ActiveRecord::Base

  set_table_name :cons_cons_types

  query_extend
  acts_as_customizable

  scope :with_consType_message,lambda{

                             }

end
