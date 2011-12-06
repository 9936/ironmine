class Chm::ChangePrioritiesTl < ActiveRecord::Base
  set_table_name :chm_change_priorities_tl

  belongs_to :change_priority

  validates_presence_of :name
end
