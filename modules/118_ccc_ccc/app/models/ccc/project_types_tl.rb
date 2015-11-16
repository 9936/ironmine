class Ccc::ProjectTypesTl < ActiveRecord::Base
  set_table_name :ccc_project_types_tl

  belongs_to :project_type

  validates_presence_of :name
end
