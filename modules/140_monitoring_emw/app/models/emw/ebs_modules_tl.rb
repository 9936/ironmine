class Emw::EbsModulesTl < ActiveRecord::Base
  set_table_name :emw_ebs_modules_tl

  belongs_to :ebs_module
end