class Ccc::ConsultantTypesTl < ActiveRecord::Base
  set_table_name :ccc_consultant_types_tl

  belongs_to :consultant_type

  validates_presence_of :name
end
