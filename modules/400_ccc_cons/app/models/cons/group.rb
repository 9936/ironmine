class Cons::Group < ActiveRecord::Base

  set_table_name :cons_groups

  query_extend
  acts_as_customizable

  scope :with_group_message,lambda{

                             }
end
