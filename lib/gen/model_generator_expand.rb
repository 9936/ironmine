module Gen::ModelGeneratorExpand
  def self.included(base)
    base.class_eval do
      def create_migration_file
        return unless options[:migration] && options[:parent].nil?
        migration_template "migration.rb", "#{get_module}db/migrate/create_#{table_name}.rb"
      end
    end
  end
end