module Gtd::TasksHelper
  def available_systems
    external_systems_scope = Irm::ExternalSystem.multilingual.enabled.order("CONVERT( system_name USING gbk ) ")
    external_systems_scope = external_systems_scope.uniq
    external_systems_scope.collect{|i|[i[:system_name], i[:id]]}
  end

  def available_tasks_list_options
    [[I18n.t(:label_irm_todo_task_display_opts_open), "open"],
     [I18n.t(:label_irm_todo_task_display_opts_today), "today"],
     [I18n.t(:label_irm_todo_task_display_opts_over_due), "overdue"],
     [I18n.t(:label_irm_todo_task_display_opts_next_7_days), "in7day"]]
  end

  #def available_task_types
  #  [[t(:label_gtd_task_type_task), "TASK"],
  #   [t(:label_gtd_task_type_instance), "INSTANCE"]
  #  ]
  #end

  def available_member_types
    [[t(:label_gtd_task_member_public), "PUBLIC"],
     [t(:label_gtd_task_member_private), "PRIVATE"],
     [t(:label_gtd_task_member_member), "MEMBER"]
    ]
  end

  def available_access_types
    [[t(:label_gtd_task_access_read), "READ"],
     [t(:label_gtd_task_access_edit), "EDIT"]
    ]
  end

  def available_members(person_ids)
    Irm::Person.query_by_ids(person_ids).collect{|i| i.full_name}
  end

  def available_assigned_person
    Irm::Person.joins("JOIN gtd_task_assign_explosions_v gtav ON gtav.assign_person_id = #{Irm::Person.table_name}.id").
        where("gtav.person_id=?", Irm::Person.current.id).collect{|i|[i[:full_name], i.id]}
  end

  #将任务的重复规则转变为文字含义
  def week_to_num
    {"MO" => 1, "TU" => 2, "WE" => 3, "TH" => 4, "FR" => 5, "SA" => 6, "SU" => 0}
  end
  def rule_meaning(task)
    if task.present? && task.repeat.eql?("Y")
      rule_hash = task.to_rrule_hash
      meaning = ""
      rule_hash[:interval] ||= 1
      if rule_hash[:interval] && rule_hash[:interval]> 0
        case rule_hash[:freq]
          when "DAILY"
            meaning << t(:label_gtd_task_rule_n_daily, :n => rule_hash[:interval])

          when "WEEKLY"
            meaning << t(:label_gtd_task_rule_n_weekly, :n => rule_hash[:interval])
            rule_hash[:byday].each do |week_day|
              meaning << t("date.day_names")[week_to_num[week_day]]
              meaning << ","
            end
          when "MONTHLY"
            meaning << t(:label_gtd_task_rule_n_monthly, :n => rule_hash[:interval])
            if rule_hash[:bysetpos].present? && rule_hash[:bysetpos] > 0
              meaning << t(:label_gtd_task_n_setpos, :n => rule_hash[:bysetpos])
              meaning << t("date.day_names")[week_to_num[rule_hash[:byday]]]
            elsif rule_hash[:bymonthday].present?
              meaning << t(:label_gtd_task_n_monthday, :n => rule_hash[:bymonthday][0])
            end
        end
      end
      meaning
    end
  end

end
