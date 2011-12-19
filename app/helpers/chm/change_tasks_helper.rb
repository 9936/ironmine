module Chm::ChangeTasksHelper
  def change_template_tasks(template_id)
    tasks = Chm::ChangeTask.list_all.where(:source_type=>Chm::ChangeTaskTemplate.name,:source_id=>template_id)
    grouped_change_tasks = tasks.group_by{|i| i.change_task_phase_id}
    change_task_phases = Chm::ChangeTaskPhase.multilingual.order_sequence.query_by_ids(grouped_change_tasks.keys)
    [change_task_phases,grouped_change_tasks]
  end

  def change_tasks(change_request_id)
    tasks = Chm::ChangeTask.list_all.where(:source_type=>Chm::ChangeRequest.name,:source_id=>change_request_id)
    grouped_change_tasks = tasks.group_by{|i| i.change_task_phase_id}
    change_task_phases = Chm::ChangeTaskPhase.multilingual.order_sequence.query_by_ids(grouped_change_tasks.keys)
    [change_task_phases,grouped_change_tasks]
  end

  def except_self_change_tasks(change_request_id,task_id)
    tasks = Chm::ChangeTask.list_all.where(:source_type=>Chm::ChangeRequest.name,:source_id=>change_request_id).where("#{Chm::ChangeTask.table_name}.id != ?",task_id)
    grouped_change_tasks = tasks.group_by{|i| i.change_task_phase_id}
    change_task_phases = Chm::ChangeTaskPhase.multilingual.order_sequence.query_by_ids(grouped_change_tasks.keys)
    [change_task_phases,grouped_change_tasks]
  end

end