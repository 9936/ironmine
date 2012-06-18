module SchemaStatements
    def add_column_options!(sql, options) #:nodoc:
      if options[:collate]
        sql << " COLLATE #{options[:collate]}"
      else
        ci_array = ["id","created_by","updated_by"]
        if(options[:column]&&"string".eql?(options[:column].type)&&options[:column].name&&(ci_array.include?(options[:column].name.to_s)||options[:column].name.to_s.end_with?("id")))
          sql << " COLLATE utf8_bin"
        end
      end
      sql << " DEFAULT #{quote(options[:default], options[:column])}" if options_include_default?(options)
      # must explicitly check for :null to allow change_column to work on migrations
      if options[:null] == false
        sql << " NOT NULL"
      end
    end
end

ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include,SchemaStatements)  if defined? Mysql2


# 新增加覆盖原来task的方法
Rake::TaskManager.class_eval do
  def alias_task(old_name, new_name)
    @tasks[new_name] = @tasks.delete(old_name)
  end
end
Rake.application.alias_task("db:migrate", "db:migrate_original")

namespace :db do
  desc "(For Ironmine)Migrate the database (options: VERSION=x, VERBOSE=false,PRODUCT=sr)."
  task :migrate => :environment do
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    # main app migrate
    migrate_paths = ["db/*/*"]
    # modules migrate
    Rails.application.paths["db/migrate"][0..Rails.application.paths["db/migrate"].length-2].each do |f|
      migrate_paths << "#{f.to_s.gsub('migrate','')}/*"
    end if Rails.application.paths["db/migrate"].length > 1

    Irm::Migrator::TableMigrator.migrate(migrate_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end

  namespace :irm do
    desc "(For Ironmine) Sync Data Access"
    task :sync_data_access => :environment do
      ActiveRecord::Base.connection.execute("DELETE FROM irm_data_accesses_t")
      ActiveRecord::Base.connection.execute("INSERT INTO irm_data_accesses_t(opu_id,business_object_id,bo_model_name,source_person_id,target_person_id,access_level,created_at) SELECT *,NOW() FROM irm_data_accesses_v")
    end
  end
end

