module Gen::CssScaffoldGeneratorExpand
  def self.included(base)
    base.class_eval do
      def copy_stylesheet
        dir = Rails::Generators::ScaffoldGenerator.source_root
        file = File.join(dir, "scaffold.css")
        create_file "#{get_module}app/assets/stylesheets/scaffold.css", File.read(file)
      end
    end
  end
end