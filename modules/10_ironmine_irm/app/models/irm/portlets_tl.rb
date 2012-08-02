class Irm::PortletsTl < ActiveRecord::Base
  set_table_name :irm_portlets_tl

  belongs_to :portlet
  validates_presence_of :name
end
