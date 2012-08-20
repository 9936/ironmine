module Gen::ControllerGeneratorExpand
  def self.included(base)
    base.class_eval do
      #扩展生成视图的文件夹
      def copy_view_files
        base_path = File.join("#{get_module}app/views", class_path, file_name)
        empty_directory base_path

        actions.each do |action|
          @action = action
          @path = File.join(base_path, filename_with_extensions(action))
          template filename_with_extensions(:view), @path
        end
      end

      protected
        def available_views
          %w(index edit show _new_form _edit_form get_data)
        end
    end
  end
end
