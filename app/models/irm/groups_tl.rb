class Irm::GroupsTl < ActiveRecord::Base
  set_table_name :irm_groups_tl

  belongs_to :group

  validates_presence_of :name
end
