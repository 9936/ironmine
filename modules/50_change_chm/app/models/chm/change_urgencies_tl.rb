class Chm::ChangeUrgenciesTl < ActiveRecord::Base
  set_table_name :chm_change_urgencies_tl

  belongs_to :change_urgency

  validates_presence_of :name
end
