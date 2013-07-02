# 新增加覆盖原来task的方法
Rake::TaskManager.class_eval do
  def alias_task(old_name, new_name)
    @tasks[new_name] = @tasks.delete(old_name)
  end
end
Rake.application.alias_task("stats", "stats_original")
origin_directories =[
  #%w(Controllers        app/controllers),
  #%w(Helpers            app/helpers),
  #%w(Models             app/models),
  #%w(Libraries          lib/),
  %w(APIs               app/apis),
  %w(Integration\ tests test/integration),
  %w(Functional\ tests  test/functional),
  %w(Unit\ tests        test/unit)
]

dirs = %w[app/controllers app/helpers app/models lib]

Rails.application.config.fwk.modules.each do |module_name|
  Rails.application.config.paths.keys.each do |key|
    next unless Rails.application.config.paths[key].is_a?(Array)
    Rails.application.config.paths[key].each_with_index do |path,i|
      if key.eql?("app/controllers")
        origin_directories << ["#{i}Controllers",path]
      elsif key.eql?("app/helpers")
        origin_directories << ["#{i}Helpers",path]
      elsif key.eql?("app/models")
        origin_directories << ["#{i}Models",path]
      elsif key.eql?("lib")
        origin_directories << ["#{i}Libraries",path]
      end
    end

  end

end


STATS_DIRECTORIES = origin_directories.collect { |name, dir| [ name, "#{Rails.root}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  require 'rails/code_statistics'
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end
