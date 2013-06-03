module Gtd::NotifyProgramsHelper
  #def available_task_types
  #  [[t(:label_gtd_notify_program_task_type_daily), "DAILY"],
  #   [t(:label_gtd_notify_program_task_type_weekly), "WEEKLY"],
  #   [t(:label_gtd_notify_program_task_type_monthly), "MONTHLY"]
  #  ]
  #end

  def available_notify_types
    [[t(:label_gtd_notify_program_notify_type_email), "EMAIL"],
     [t(:label_gtd_notify_program_notify_type_incident), "INCIDENT"]]
  end

  #查询出紧急度
  def get_urgence(urgence_id)
    urgence_code = Icm::UrgenceCode.multilingual.where(:id => urgence_id).first
    if urgence_code.present?
      return urgence_code[:name]
    end
  end

  #查询出影响度
  def get_impact_range(impact_range_id)
    impact_range = Icm::ImpactRange.multilingual.where(:id => impact_range_id).first
    if impact_range.present?
      return impact_range[:name]
    end
  end

end
