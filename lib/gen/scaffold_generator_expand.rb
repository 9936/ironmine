module Gen::ScaffoldGeneratorExpand
  def self.included(base)
    base.class_eval do
      #扩展生成视图的文件夹
      def create_root_folder
        empty_directory File.join("#{get_module}app/views", controller_file_path)
      end

      protected

      def available_views
        %w(index edit show _new_form _edit_form get_data)
      end
    end
  end
end
