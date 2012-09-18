class Icm::AssignRule < ActiveRecord::Base
  set_table_name :icm_assign_rules

  attr_accessor :assignment_str

  before_create :build_sequence
  validates_presence_of :name, :support_group_id

  belongs_to :support_group, :class_name => "Icm::SupportGroup"
  has_many :group_assignments, :dependent => :destroy, :class_name => "Icm::GroupAssignment"

  scope :order_by_sequence,lambda{
     self.order("sequence ASC")
  }

  # create assignment from str
  def create_assignment_from_str
    return unless self.assignment_str
    str_values = self.assignment_str.split(",").delete_if{|i| !i.present?}
    exists_values = Icm::GroupAssignment.where(:assign_rule_id=>self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.source_type}##{value.source_id}")
        str_values.delete("#{value.source_type}##{value.source_id}")
      else
        value.destroy
      end
    end
    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      self.group_assignments.create(:source_type=>value[0],:source_id=>value[1])
    end
  end

  def get_assignment_str
    return @get_assignment_str if @get_assignment_str
    @get_assignment_str = self.group_assignments.collect{|value| "#{value.source_type}##{value.source_id}"}.join(",")
    @get_assignment_str
  end


  #前一条规则
  def pre_rule
    pre_rule = Icm::AssignRule.where("sequence < ?", self.sequence).order("sequence DESC").first
    if pre_rule.present?
      pre_rule
    else
      self
    end
  end

  #后一条规则
  def next_rule
    next_rule = Icm::AssignRule.where("sequence > ?", self.sequence).order("sequence ASC").first
    if next_rule.present?
      next_rule
    else
      self
    end
  end

  private
    #构建sequence
    def build_sequence
      current_sequence = Icm::AssignRule.select("sequence").order("sequence DESC").first
      if current_sequence.present?
        self.sequence = current_sequence[:sequence] + 1
      else
        self.sequence = 1
      end
    end

end
