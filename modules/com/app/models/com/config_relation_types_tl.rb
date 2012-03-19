class Com::ConfigRelationTypesTl < ActiveRecord::Base
  set_table_name :com_config_relation_types_tl

  belongs_to :config_relation_type
  validates_presence_of :name
end
