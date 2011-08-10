class Irm::TabsTl < ActiveRecord::Base
  set_table_name :irm_tabs_tl

  belongs_to :tab

  validates_presence_of :name
end
