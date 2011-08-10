class Irm::ProfileApplication < ActiveRecord::Base
  set_table_name :irm_profile_applications

  belongs_to :applicaiton
  belongs_to :profile
end
