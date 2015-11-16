class Ccc::ConsultantLevelsTl < ActiveRecord::Base
  set_table_name :ccc_consultant_levels_tl

  belongs_to :consultant_level

  validates_presence_of :name
end
