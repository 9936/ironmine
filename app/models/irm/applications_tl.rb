class Irm::ApplicationsTl < ActiveRecord::Base
  set_table_name :irm_applications_tl

  belongs_to :application

  validates_presence_of :name
end
