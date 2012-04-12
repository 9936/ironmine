module Gen::JsAssetsGeneratorExpand
  def self.included(base)
    base.class_eval do
      def copy_javascript
        copy_file "javascript.js", File.join("#{get_module}app/assets/javascripts", class_path, "#{file_name}.js")
      end
    end
  end
end