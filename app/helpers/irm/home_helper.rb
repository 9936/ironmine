module Irm::HomeHelper
  def my_task_entries
    values = []
    Ironmine::Acts::Task::Helper.task_entries.each do |te|
      values << [Irm::BusinessObject.class_name_to_meaning(te),te]
    end
    values
  end
end
