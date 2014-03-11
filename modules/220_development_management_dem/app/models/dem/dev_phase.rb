class Dem::DevPhase< ActiveRecord::Base
  set_table_name 'dem_dev_phases'
  belongs_to :dev_management
  belongs_to :dev_phase_template
  #加入activerecord的通用方法和scope
  query_extend
  attr_accessor :temp_id
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :with_template, lambda{
        select("#{table_name}.owner_1, #{table_name}.owner_2, #{table_name}.owner_3, #{table_name}.owner_4, #{table_name}.owner_5, #{table_name}.owner_6 ").
        select("#{table_name}.status, #{table_name}.display_sequence, #{table_name}.plan_start, #{table_name}.plan_end, #{table_name}.real_start, #{table_name}.real_end").
        select("#{table_name}.created_at").
        select("#{table_name}.id id").
        joins(",#{Dem::DevPhaseTemplate.table_name} dpt").
        where("#{table_name}.dev_phase_template_id = dpt.id").
        select("dpt.name name, dpt.owner_1_label, dpt.owner_2_label, dpt.owner_3_label, dpt.owner_4_label, dpt.owner_5_label, dpt.owner_6_label ").
        select("dpt.status_label, dpt.plan_start_label, dpt.plan_end_label, dpt.real_start_label, dpt.real_end_label")
  }

  scope :with_phase_status, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vstatus ON vstatus.lookup_type = 'DEM_PHASE_STATUS' AND vstatus.lookup_code = #{table_name}.status AND vstatus.language = '#{language}'").
        select("vstatus.meaning phase_status_name")
  }

  def owners
    arr = Array.new()
    arr << self.owner_1 if self.dev_phase_template.owner_1_label.present? && self.owner_1.present?
    arr << self.owner_2 if self.dev_phase_template.owner_2_label.present? && self.owner_2.present?
    arr << self.owner_3 if self.dev_phase_template.owner_3_label.present? && self.owner_3.present?
    arr << self.owner_4 if self.dev_phase_template.owner_4_label.present? && self.owner_4.present?
    arr << self.owner_5 if self.dev_phase_template.owner_5_label.present? && self.owner_5.present?
    arr << self.owner_6 if self.dev_phase_template.owner_6_label.present? && self.owner_6.present?
    return arr.join(',')
  end
end
