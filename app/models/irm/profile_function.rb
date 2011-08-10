class Irm::ProfileFunction < ActiveRecord::Base
  set_table_name :irm_profile_functions

  belongs_to :function
  belongs_to :profile
end
