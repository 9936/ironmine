class Irm::PortalLayoutsTl < ActiveRecord::Base
  set_table_name :irm_port_layouts_tl

  belongs_to :portal_layout
  validates_presence_of :name
end
