class Irm::ObjectAttributeSystem < ActiveRecord::Base
  set_table_name :irm_object_attribute_systems

  validates_presence_of :external_system_id, :object_attribute_id
  validates_uniqueness_of :object_attribute_id, :scope => [:external_system_id]

  before_create :build_sequence

  private
  #构建sequence
  def build_sequence
    current_sequence = Irm::ObjectAttributeSystem.select("display_sequence").where(:external_system_id => self.external_system_id).order("display_sequence DESC").first
    if current_sequence.present?
      self.display_sequence = current_sequence[:display_sequence] + 1
    else
      self.display_sequence = 1
    end
  end
end