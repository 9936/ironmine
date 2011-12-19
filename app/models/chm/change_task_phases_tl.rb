class Chm::ChangeTaskPhasesTl < ActiveRecord::Base
  set_table_name :chm_change_task_phases_tl

  belongs_to :change_task_phase

  validates_presence_of :name
end
