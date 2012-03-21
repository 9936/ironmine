module Gen::ScaffoldGeneratorExpand
  def self.included(base)
    base.class_eval do
      #扩展生成视图的文件夹
      def create_root_folder
        empty_directory File.join("#{get_module}app/views", controller_file_path)
      end
    end
  end
end
