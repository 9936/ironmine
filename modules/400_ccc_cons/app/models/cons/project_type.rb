class Cons::ProjectType < ActiveRecord::Base

  set_table_name :cons_project_types

  query_extend
  acts_as_customizable

  scope :with_projectType_message,lambda{

                             }

end
