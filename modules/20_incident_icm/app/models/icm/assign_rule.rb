class Icm::AssignRule < ActiveRecord::Base
  set_table_name :icm_assign_rules

  attr_accessor :assignment_str,:custom_str

  before_create :build_sequence
  validates_presence_of :name, :support_group_id

  belongs_to :support_group, :class_name => "Icm::SupportGroup"
  has_many :group_assignments, :dependent => :destroy, :class_name => "Icm::GroupAssignment"

  scope :enabled, lambda{
    self.where(:status_code => Irm::Constant::ENABLED)
  }

  scope :disabled, lambda{
    self.where(:status_code => Irm::Constant::DISABLED)
  }

  scope :order_by_sequence,lambda{
     self.order("sequence ASC")
  }

  scope :with_external_system, lambda{|external_system_id|
    self.where("external_system_id=?", external_system_id)
  }


  def self.next_active_sequence
    active_assign_rule = Icm::AssignRule.select("sequence").enabled.order("sequence DESC").first
    if active_assign_rule.present?
      return active_assign_rule[:sequence] + 1
    else
      0
    end
  end

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
    if str_values.any?
      str_values.each do |value_str|
        next unless value_str.strip.present?
        value = value_str.strip.split("#")
        self.group_assignments.create(:source_type=>value[0],:source_id=>value[1], :custom_str => custom_str)
      end
    elsif custom_str.present?
      self.group_assignments.create(:source_type=> 0, :source_id=> 0, :custom_str => custom_str)
    end
  end

  def get_assignment_str
    return @get_assignment_str if @get_assignment_str
    @get_assignment_str = self.group_assignments.collect{|value| "#{value.source_type}##{value.source_id}"}.join(",")
    @get_assignment_str
  end

  def custom_hash
    return eval(self.custom_str) if self.custom_str.present?
    if self.group_assignments.any?
      self.custom_str = self.group_assignments.first.custom_str
    else
      return {}
    end
    eval(custom_str)
  end

  #根据事故单寻找分配组
  def self.get_support_group_by_incident(incident_request_id, external_system_id)
    assign_rule_result = nil
    self.enabled.order_by_sequence.with_external_system(external_system_id).each do |assign_rule|
      if assign_rule.build_sql(incident_request_id, external_system_id).any?
        assign_rule_result = assign_rule
        break
      end
    end
    assign_rule_result
  end

  #组拼sql语句
  def build_sql(incident_request_id, external_system_id)
    sql_str = "SELECT DISTINCT ir.id FROM icm_incident_requests ir LEFT JOIN irm_person_relations_v irv ON ir.requested_by = irv.person_id"
    if self.group_assignments.any?
      where_arr = []
      if self.group_assignments.collect(&:source_type).include?("IRM__ORGANIZATION_EXPLOSION")
        sql_str += " LEFT JOIN irm_organization_explosions ire ON ir.organization_id = ire.organization_id"
      end
      sql_str += " WHERE(ir.id='#{incident_request_id}' AND ir.external_system_id='#{external_system_id}') AND ("
      self.group_assignments.each do |ga|
        #将事故单的属性组装SQL
        if ga.custom_str.present?
          custom_str_hash = eval(ga.custom_str)
          custom_str_hash.each do |k,v|
            where_arr << "(ir.#{k}='#{v}')"
          end if custom_str_hash.any?
        end

        case ga.source_type.to_s
          when "ICM__INCIDENT_CATEGORY"
            where_arr << "(ir.incident_category_id='#{ga.source_id}')"
          when "IRM__ORGANIZATION"
            where_arr << "(ir.organization_id='#{ga.source_id}')"
          when "IRM__ORGANIZATION_EXPLOSION"
            where_arr << "(ire.organization_id= '#{ga.source_id}')"
          when "IRM__EXTERNAL_SYSTEM"
            where_arr << "(ir.external_system_id='#{ga.source_id}')"
          when "IRM__ROLE","IRM__ROLE_EXPLOSION","IRM__GROUP","IRM__GROUP_EXPLOSION","IRM__PERSON"
            where_arr << "(irv.source_type='#{ga.source_type}' AND irv.source_id = '#{ga.source_id}')"
        end
      end
      sql_str += where_arr.join(" #{self.join_type} ") if where_arr.any?
      sql_str += " )"
    end
    Icm::IncidentRequest.find_by_sql(sql_str)
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
