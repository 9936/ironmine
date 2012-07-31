class Com::ConfigItemStatusesTl < ActiveRecord::Base
  set_table_name :com_config_item_statuses_tl

  belongs_to :config_item_status
  validates_presence_of :name
end