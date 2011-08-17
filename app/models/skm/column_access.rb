class Skm::ColumnAccess < ActiveRecord::Base
  set_table_name :skm_column_accesses
  belongs_to :column
  belongs_to :source, :polymorphic => true
end