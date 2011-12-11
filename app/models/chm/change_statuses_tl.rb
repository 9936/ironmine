class Chm::ChangeStatusesTl < ActiveRecord::Base
  set_table_name :chm_change_statuses_tl

  belongs_to :change_status

  validates_presence_of :name
end
