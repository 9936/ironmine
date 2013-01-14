class Icm::SystemGroupProcess < ActiveRecord::Base
  set_table_name :icm_group_processes

  before_create :build_sequence

  has_many :group_process_relations, :class_name => "Icm::GroupProcessRelation", :foreign_key => "group_process_id", :dependent => :destroy

  validates_presence_of :external_system_id


  def self.get_group_process(external_system_id, category_id='', sub_category_id='', urgence_id='', impact_range_id='')
    all_group_processes = self.where("external_system_id=?",external_system_id).order_by_sequence
    target_str = ""
    target_str += "CID=#{category_id}"
    target_str += "SUB_CID=#{sub_category_id}"
    target_str += "URGID=#{urgence_id}"
    target_str += "IRID=#{impact_range_id}"
    all_group_processes.each do |gp|
      if gp.match_process.eql?(target_str)
        return gp.id
      end
    end if all_group_processes.any?
    return nil
  end

  def match_process
    result = ""
    if self.category_id.present?
      result += "CID=#{self.category_id}"
    else
      result += "CID="
    end

    if self.sub_category_id.present?
      result += "SUB_CID=#{self.sub_category_id}"
    else
      result += "SUB_CID="
    end

    if self.urgence_id.present?
      result += "URGID=#{self.urgence_id}"
    else
      result += "URGID="
    end
    if self.impact_range_id.present?
      result += "IRID=#{self.impact_range_id}"
    else
      result += "IRID="
    end
    result
  end

  scope :select_all,lambda{
    select("#{table_name}.*")
  }

  def self.list_all(external_system_id)
    select_all.
        with_external_system(external_system_id, I18n.locale).
        with_category(I18n.locale).
        with_urgence(I18n.locale).
        with_impact_range(I18n.locale).
        order_by_sequence
  end

  scope :order_by_sequence,lambda{
    self.order("display_sequence ASC")
  }

  scope :with_external_system, lambda{|external_system_id, language|
    joins("LEFT OUTER JOIN #{Irm::ExternalSystem.view_name} external_system ON external_system.id = #{table_name}.external_system_id AND external_system.language = '#{language}'").
        where("#{table_name}.external_system_id=?", external_system_id).
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
