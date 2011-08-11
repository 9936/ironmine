class Irm::BuColumnsTl < ActiveRecord::Base
  set_table_name :irm_bu_columns_tl
  belongs_to :bu_column
  validates_presence_of :name
end