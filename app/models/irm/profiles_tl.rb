class Irm::ProfilesTl < ActiveRecord::Base
  set_table_name :irm_profiles_tl

  belongs_to :profile

  validates_presence_of :name
end
