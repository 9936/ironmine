class Dem::DevManagement< ActiveRecord::Base
  set_table_name 'dem_dev_managements'
  #加入activerecord的通用方法和scope
  query_extend
  belongs_to :project
  has_many :dev_phases, :dependent => :destroy

  validates_presence_of :project_id, :gap_no

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

  scope :with_project, lambda{
    joins(",#{Dem::Project.table_name} p").
        where("p.status_code = ?", "ENABLED").
        where("p.id = #{table_name}.project_id").
        select("p.name project, p.description project_description")
  }

  scope :with_related_project, lambda{
    joins("LEFT OUTER JOIN #{Dem::Project.table_name} rp ON rp.status_code = 'ENABLED' AND rp.id = #{table_name}.related_project_id").
        select("rp.name related_project")
  }

  scope :with_method, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vmethod ON vmethod.lookup_type = 'DEM_DEVELOP_METHOD' AND vmethod.lookup_code = #{table_name}.classification AND vmethod.language = '#{language}'").
        select("vmethod.meaning classification_name")
  }

  scope :with_module, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vmodule ON vmodule.lookup_type = 'DEM_MODULE' AND vmodule.lookup_code = #{table_name}.category AND vmodule.language = '#{language}'").
        select("vmodule.meaning category_name")
  }

  scope :with_dev_difficulty, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} vdifficulty ON vdifficulty.lookup_type = 'DEM_DIFFICULTY' AND vdifficulty.lookup_code = #{table_name}.dev_difficulty AND vdifficulty.language = '#{language}'").
        select("vdifficulty.meaning dev_difficulty_name")
  }

  def update_trigger
    if self.dev_phases.any?
      #update status
      #Max([Phase].status = completed).name
      completed_phases = Dem::DevPhase.
          joins(",#{Dem::DevPhaseTemplate.table_name} dt").
          select("#{Dem::DevPhase.table_name}.*").
          select("dt.current_status current_status").
          where("dt.id = #{Dem::DevPhase.table_name}.dev_phase_template_id").
          where("dev_management_id = ?", self.id).
          where("status = ?", "DEM_PHASE_COMPLETED").
          order("display_sequence DESC, created_at DESC")

      phases = Dem::DevPhase.
          joins(",#{Dem::DevPhaseTemplate.table_name} dt").
          select("#{Dem::DevPhase.table_name}.*").
          select("dt.current_status current_status").
          where("dt.id = #{Dem::DevPhase.table_name}.dev_phase_template_id").
          where("dev_management_id = ?", self.id).
          order("display_sequence ASC, created_at ASC")

      status = "Waiting For MD050"

      begin
        status = "Waiting For " + completed_phases.last.current_status
      rescue
        status = phases.first.current_status
      end
    end

    #update owner
    #Max([Phase].status = completed).owners
    owner = self.owner
    begin
      if completed_phases.size == 0
        owner = phases.first.owners
      elsif phases.size == 1 || (phases.size > 1 && completed_phases.size == phases.size)
        owner = phases.last.owners
      elsif phases.size > 1 && completed_phases.any?
        index = phases.index(completed_phases.first)
        owner = phases[index + 1].owners if index + 1 < phases.size
      end
    rescue
      nil
    end

    self.update_attributes(:dev_status => status, :owner => owner)
  end
end
