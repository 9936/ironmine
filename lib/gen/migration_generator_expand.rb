module Gen::MigrationGeneratorExpand
  def self.included(base)
    base.class_eval do
      def create_migration_file
        set_local_assigns!
        migration_template "migration.rb", "#{get_module}db/migrate/#{file_name}.rb"
      end
    end
  end
end