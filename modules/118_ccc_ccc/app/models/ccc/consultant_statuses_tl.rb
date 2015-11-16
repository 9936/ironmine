class Ccc::ConsultantStatusesTl < ActiveRecord::Base
  set_table_name :ccc_consultant_statuses_tl

  belongs_to :consultant_status

  validates_presence_of :name
end
