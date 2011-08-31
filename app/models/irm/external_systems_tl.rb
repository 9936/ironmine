class Irm::ExternalSystemsTl < ActiveRecord::Base
  set_table_name :irm_external_systems_tl

  belongs_to :external_system

end
