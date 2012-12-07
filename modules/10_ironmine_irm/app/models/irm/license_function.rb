class Irm::LicenseFunction < ActiveRecord::Base
  set_table_name :irm_license_functions

  belongs_to :function
  belongs_to :license
end
