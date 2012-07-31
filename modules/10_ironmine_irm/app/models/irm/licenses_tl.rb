class Irm::LicensesTl < ActiveRecord::Base
  set_table_name :irm_licenses_tl

  belongs_to :license

  validates_presence_of :name
end
