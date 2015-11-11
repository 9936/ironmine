class Cons::Industry < ActiveRecord::Base

  set_table_name :cons_industries

  query_extend
  acts_as_customizable

  # acts_as_multilingual

  scope :with_industry_message,lambda{

                             }
end
