class Dem::DevManagement< ActiveRecord::Base
  set_table_name 'dem_dev_managements'
  #加入activerecord的通用方法和scope
  query_extend

  has_many :dev_phases, :dependent => :destroy

  validates_presence_of :project, :gap_no

  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :with_phases, lambda{
    joins("LEFT OUTER JOIN #{Dem::DevPhase.table_name} dp ON dp.dev_management_id = #{table_name}.id").
        select("dp.owner_1, dp.owner_2, dp.owner_3, dp.owner_4, dp.owner_5, dp.owner_6 ").
        select("dp.status, dp.display_sequence, dp.plan_start, dp.plan_end, dp.real_start, dp.real_end").
        joins("LEFT OUTER JOIN #{Dem::DevPhaseTemplate.table_name} dpt ON dp.dev_phase_template_id = dpt.id").
        select("dpt.owner_1_label, dpt.owner_2_label, dpt.owner_3_label, dpt.owner_4_label, dpt.owner_5_label, dpt.owner_6_label ").
        select("dpt.status_label, dpt.plan_start_label, dpt.plan_end_label, dpt.real_start_label, dpt.real_end_label")
  }
end
