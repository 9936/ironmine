module Gen::CssAssetsGeneratorExpand
  def self.included(base)
    base.class_eval do
      def copy_stylesheet
        copy_file "stylesheet.css", File.join("#{get_module}app/assets/stylesheets", class_path, "#{file_name}.css")
      end
    end
  end
end