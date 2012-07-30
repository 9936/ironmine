module Fwk
  class Railtie < Rails::Railtie
    #配置框架
    config.before_configuration do
      # 配置
      config.irm = ActiveSupport::OrderedOptions.new
      # 模块目录
      config.irm.module_folder = 'modules'
      # 模块名称与目录对应hash
      config.irm.module_mapping = {}
      # 系统模块
      config.irm.modules = []
      Dir["#{Rails.root}/#{config.irm.module_folder}/*"].sort.each { |i|
        if File.directory?(i)
          config.irm.module_mapping.merge!({File.basename(i).split("_").last => File.basename(i)})
          config.irm.modules << File.basename(i).split("_").last
        end
      }
      # 对系统模块加载顺序排序
      config.irm.modules.sort! { |a, b| a.split("_").first.to_i<=>b.split("_").first.to_i }
      config.irm.languages = [:zh, :en]
      # javascript与css
      config.irm.jscss = {}

      # 配置基础模块javascript css
      config.irm.jscss.merge!({
                                  :default => {:css => ["application"], :js => ["application", "locales/jquery-{locale}"]},
                                  :default_ie6 => {:css => ["application-ie6"], :js => ["application", "locales/jquery-{locale}"]},
                                  :aceditor => {:js => ["plugins/ace"]},
                                  :xheditor => {:css => ["plugins/xheditor"], :js => ["plugins/xheditor/xheditor-{locale}"]},
                                  :jpolite => {:css => ["plugins/jpolite"], :js => ["plugins/jpolite"]},
                                  :jcrop => {:css => ["plugins/jcrop"], :js => ["plugins/jquery-crop"]},
                                  :jcrop_ie6 => {:css => ["plugins/jcrop-ie6"], :js => []},
                                  :highcharts => {:css => [], :js => ["highcharts"]},
                                  :login => {:css => ["login"], :js => []},
                                  :login_ie6 => {:css => ["login-ie6"]},
                                  :jquery_ui => {:js => ["jquery-ui"]},
                                  :gollum => {:js => ["plugins/gollum"], :css => ["plugins/gollum"]},
                                  :markdown => {:css => ["markdown"]}
                              })
    end

    # 自动对资源文件进行预编译
    initializer "sprockets.environment" do |app|
      config = app.config
      config.irm.jscss.values.each do |asset|
        files = []

        asset[:css].each do |css|
          if css.to_s.include?("{locale}")
            config.irm.languages.each do |lang|
              files << css.to_s.gsub("{locale}", lang.to_s).to_s+".css"
            end
          else
            files << "#{css}.css"
          end
        end if asset[:css]
        asset[:js].each do |js|
          if js.to_s.include?("{locale}")
            config.irm.languages.each do |lang|
              files << js.to_s.gsub("{locale}", lang.to_s).to_s+".js"
            end
          else
            files << "#{js}.js"
          end
        end if asset[:js]
        config.assets.precompile += files
      end
      config.assets.precompile +=  ["report_types.css"]
    end

    #扩展rails 的生成器generators
    generators do
      #扩展Rails::Generators::NamedBase
      Rails::Generators::NamedBase.send(:include, Gen::GeneratorExpand)
      #扩展Erb::Generators::ScaffoldGenerator，解决设置--module= xx 以在app/view/xx空文件夹
      require 'rails/generators/erb/scaffold/scaffold_generator'
      Erb::Generators::ScaffoldGenerator.send(:include, Gen::ScaffoldGeneratorExpand)
      #扩展ActiveRecord::Generators::MigrationGenerator，解决在设置--module= xx 参数后引起migration文件目录异常
      require 'rails/generators/active_record/migration/migration_generator'
      ActiveRecord::Generators::MigrationGenerator.send(:include, Gen::MigrationGeneratorExpand)
      #扩展ActiveRecord::Generators::ModelGenerator，解决在设置--module= xx 参数后引起migration文件目录异常
      require 'rails/generators/active_record/model/model_generator'
      ActiveRecord::Generators::ModelGenerator.send(:include, Gen::ModelGeneratorExpand)

      #由于不同版本rails生成器的差异，该版本中不能扩展扩展Sass::Generators::ScaffoldBase，需要用如下进行替代
      require 'rails/generators/css/scaffold/scaffold_generator'
      Css::Generators::ScaffoldGenerator.send(:include, Gen::CssScaffoldGeneratorExpand)
      require 'rails/generators/js/assets/assets_generator'
      Js::Generators::AssetsGenerator.send(:include, Gen::JsAssetsGeneratorExpand)
      require 'rails/generators/css/assets/assets_generator'
      Css::Generators::AssetsGenerator.send(:include, Gen::CssAssetsGeneratorExpand)
      # #扩展Sass::Generators::ScaffoldBase，解决在设置--module= xx 参数后生成的scaffold.css.xx 不在指定目录下
      # require 'rails/generators/sass_scaffold'
      # Sass::Generators::ScaffoldBase.send(:include, Gen::SassScaffoldGeneratorExpand)

      #扩展Erb::Generators::ControllerGenerator 解决在设置--module= xx 参数后运行rails g controller命令在app/view/下生成一个xx空文件夹
      require 'rails/generators/erb/controller/controller_generator'
      Erb::Generators::ControllerGenerator.send(:include, Gen::ControllerGeneratorExpand)
    end

  end
end