class Cons::Module < ActiveRecord::Base

  set_table_name :cons_modules

  query_extend
  acts_as_customizable

  scope :with_module_message,lambda{

                             }

end
