class Skm::ColumnsTl < ActiveRecord::Base
  set_table_name :skm_columns_tl
  belongs_to :column, :class_name => 'Skm::Column'
  validates_presence_of :name
end