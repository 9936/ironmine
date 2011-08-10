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
    product_path = ENV["PRODUCT"] ? "/#{ENV['PRODUCT']}" : "/*"
    data_table_path = ENV["TABLE"] ? "db/migrate#{product_path}":"db/*#{product_path}"
    Irm::Migrator::TableMigrator.migrate(data_table_path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end
end