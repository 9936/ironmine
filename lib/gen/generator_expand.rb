module Gen::GeneratorExpand
  def self.included(base)
    base.class_eval do
      class_option :module, :type => :string, :default => "", :desc => "tell which module to place the files"

      #重载模板方法
      no_tasks do
        def template(source, *args, &block)
         unless source.eql?('migration.rb')
            args.each_with_index do |arg,index|
              args[index] = "#{get_module}#{arg}"
            end
          end
          inside_template do
            super
          end
        end
      end

      #获取传递过来的参数判断是否含有module
      def get_module
        if !options[:module].present?
          ""
        else
          if Rails.application.config.irm.module_mapping[options[:module]]
            "#{Rails.application.config.irm.module_folder||"modules"}/#{Rails.application.config.irm.module_mapping[options[:module]]}/"
          else
            ""
          end
        end
      end
    end
  end
end
