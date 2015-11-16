class Ccc::ConsultantModulesTl < ActiveRecord::Base
  set_table_name :ccc_consultant_modules_tl

  belongs_to :consultant_module

  validates_presence_of :name
end
