class Com::ConfigClassesTl < ActiveRecord::Base
  set_table_name :com_config_classes_tl

  belongs_to :config_class
  validates_presence_of :name
end