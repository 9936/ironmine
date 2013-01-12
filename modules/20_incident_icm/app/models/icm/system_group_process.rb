class Icm::SystemGroupProcess < ActiveRecord::Base
  set_table_name :icm_group_processes

  before_create :build_sequence

  has_many :group_process_relations, :class_name => "Icm::GroupProcessRelation", :foreign_key => "group_process_id", :dependent => :destroy

  validates_presence_of :external_system_id
  #attr_accessor :support_group_ids_str


  scope :select_all,lambda{
    select("#{table_name}.*")
  }

  def self.list_all
    select_all.
        with_external_system(I18n.locale).
        with_category(I18n.locale).
        with_urgence(I18n.locale).
        with_impact_range(I18n.locale).
        order_by_sequence
  end

  scope :order_by_sequence,lambda{
    self.order("display_sequence ASC")
  }

  scope :with_external_system, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::ExternalSystem.view_name} external_system ON external_system.id = #{table_name}.external_system_id AND external_system.language = '#{language}'").
        select("external_system.system_name external_system_name")
  }

  # 查询出紧急度
  scope :with_urgence,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::UrgenceCode.view_name} urgence_code ON  urgence_code.id = #{table_name}.urgence_id AND urgence_code.language= '#{language}'").
        select(" urgence_code.name urgence_name")
  }
  # 查询出影响度
  scope :with_impact_range,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::ImpactRange.view_name} impact_range ON  impact_range.id = #{table_name}.impact_range_id AND impact_range.language= '#{language}'").
        select(" impact_range.name impact_range_name")
  }

  scope :with_category,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::IncidentCategory.view_name} ON  #{Icm::IncidentCategory.view_name}.id = #{table_name}.category_id AND #{Icm::IncidentCategory.view_name}.language= '#{language}'").
        joins("LEFT OUTER JOIN #{Icm::IncidentSubCategory.view_name} ON  #{Icm::IncidentSubCategory.view_name}.id = #{table_name}.sub_category_id AND #{Icm::IncidentSubCategory.view_name}.language= '#{language}'").
        select(" #{Icm::IncidentCategory.view_name}.name category_name,#{Icm::IncidentSubCategory.view_name}.name sub_category_name")
  }

  #支持组流向




  private
    #构建sequence
    def build_sequence
      current_sequence = Icm::SystemGroupProcess.select("display_sequence").order("display_sequence DESC").first
      if current_sequence.present?
        self.display_sequence = current_sequence[:display_sequence] + 1
      else
        self.display_sequence = 1
      end
    end
end
