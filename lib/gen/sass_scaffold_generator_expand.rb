module Gen::SassScaffoldGeneratorExpand
  def self.included(base)
    base.class_eval do
      def copy_stylesheet
        dir = ::Rails::Generators::ScaffoldGenerator.source_root
        file = File.join(dir, "scaffold.css")
        converted_contents = ::Sass::CSS.new(File.read(file)).render(syntax)
        create_file "#{get_module}app/assets/stylesheets/scaffolds.css.#{syntax}", converted_contents
      end
    end
  end
end