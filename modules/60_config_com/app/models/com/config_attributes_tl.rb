class Com::ConfigAttributesTl < ActiveRecord::Base
  set_table_name :com_config_attributes_tl

  belongs_to :config_attribute
  validates_presence_of :name
end