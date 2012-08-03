class Irm::OperationUnitsTl < ActiveRecord::Base
  set_table_name :irm_operation_units_tl

  after_create  :setup_opu_id

  belongs_to :operation_unit

  validates_presence_of :name

  def setup_opu_id
    self.opu_id = self.operation_unit_id
    self.save
  end
end
