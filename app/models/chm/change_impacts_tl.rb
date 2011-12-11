class Chm::ChangeImpactsTl < ActiveRecord::Base
  set_table_name :chm_change_impacts_tl

  belongs_to :change_impact

  validates_presence_of :name
end
