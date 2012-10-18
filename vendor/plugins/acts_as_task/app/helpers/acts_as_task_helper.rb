module ActsAsTaskHelper
  def acts_as_tasks(entry_type=nil)
    all_results = []
    Ironmine::Acts::Task::Helper.task_entries.each do |value|
      next if entry_type.present?&&!value.eql?(entry_type)
      task_entity = value.constantize
      if task_entity.task_options[:scope].present?&&task_entity.respond_to?(task_entity.task_options[:scope].to_sym)
        results = task_entity.send(task_entity.task_options[:scope].to_sym)
        results.each do |result|
          all_results << result.task_attributes
        end
      end
    end
    all_results = all_results.sort{|x,y| y[:start_at] <=> x[:start_at]}
    all_results
  end

end