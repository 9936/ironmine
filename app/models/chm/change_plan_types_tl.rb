class Chm::ChangePlanTypesTl < ActiveRecord::Base
  set_table_name :chm_change_plan_types_tl

  belongs_to :change_plan_type

  validates_presence_of :name
end
