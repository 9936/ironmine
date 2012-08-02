require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# 加载各模块配置
Dir["#{File.expand_path('../..', __FILE__)}/modules/*"].sort.reverse.each do |file|
  m = File.basename(file).split("_").last
  railtie_path = File.expand_path("#{file}/lib/#{m}/railtie.rb", __FILE__)
  if File.exist?(railtie_path)
    require railtie_path
  end
end

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(macdev development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Ironmine
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/ext_lib)
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = 'Beijing'

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # the flag of require login
    config.require_login_flag = true

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    #由于资源文件根据locale，i18n会读取不同的语言的资源文件然后加载到内存中
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # add mail config
    config.ironmine = ActiveSupport::OrderedOptions.new
    config.ironmine.languages = [:zh,:en]

    config.ironmine.jscss = {
        :default =>{:css=>["application"],:js=>["application","locales/jquery-{locale}"]},
        :default_ie6=>{:css=>["application-ie6"],:js=>["application","locales/jquery-{locale}"]},
        :aceditor =>{:js=>["plugins/ace"]},
        :xheditor => {:css=>["plugins/xheditor"],:js=>["plugins/xheditor/xheditor-{locale}"]} ,
        :jpolite => {:css=>["plugins/jpolite"],:js=>["plugins/jpolite"]},
        :jcrop => {:css=>["plugins/jcrop"],:js=>["plugins/jquery-crop"]},
        :jcrop_ie6 => {:css=>["plugins/jcrop-ie6"],:js=>[]},
        :highcharts => {:css=>[],:js=>["highcharts"]},
        :login => {:css=>["login"],:js=>[]},
        :login_ie6 => {:css=>["login-ie6"]},
        :jquery_ui => {:js=>["jquery-ui"]},
        :gollum => {:js=>["plugins/gollum"],:css=>["plugins/gollum"]},
        :markdown => {:css=>["markdown"]},
        :search => {:css => ["search"]}
    }
    # 自动对资源文件进行预编译
    config.ironmine.jscss.values.each do |asset|
      files = []

      asset[:css].each do |css|
        if css.to_s.include?("{locale}")
          config.ironmine.languages.each do |lang|
            files << css.to_s.gsub("{locale}",lang.to_s).to_s+".css"
          end
        else
          files << "#{css}.css"
        end
      end if asset[:css]
      asset[:js].each do |js|
        if js.to_s.include?("{locale}")
          config.ironmine.languages.each do |lang|
            files << js.to_s.gsub("{locale}",lang.to_s).to_s+".js"
          end
        else
          files << "#{js}.js"
        end
      end if asset[:js]
      config.assets.precompile +=  files
    end

    config.assets.precompile +=  ["report_types.css"]

    # 配置加载系统模块
    modules = Dir["#{config.root}/modules/*"].sort.collect{|i| File.basename(i).split("_").last if File.directory?(i)}.compact
    origin_values =  paths.dup
    modules.reverse.each do |module_name|
      paths.keys.each do |key|
        next unless paths[key].is_a?(Array)
        file_path ="modules/#{module_name}/#{origin_values[key][origin_values[key].length-1]}"
        real_file_path = "#{config.root}/#{file_path}"
        if File.exist?(real_file_path)
          paths[key].insert(0,file_path)
        end
      end
    end

    # auto load class in lib and module lib
    config.autoload_paths += paths["lib"].expanded

    # auto load program report
    config.autoload_paths += %W(#{config.root}/program/report)
    modules.reverse.each do |module_name|
      file_path = "modules/program/report"
      if File.exist?(file_path)
        config.autoload_paths += [file_path]
      end
    end


    # 自动生成时不生成asset
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
    end
    config.module_folder = 'modules'
    #扩展rails 的生成器generators
    generators do
      #扩展Rails::Generators::NamedBase
      Rails::Generators::NamedBase.send(:include,Gen::GeneratorExpand)
      #扩展Erb::Generators::ScaffoldGenerator，解决设置--module= xx 以在app/view/xx空文件夹
      require 'rails/generators/erb/scaffold/scaffold_generator'
      Erb::Generators::ScaffoldGenerator.send(:include,Gen::ScaffoldGeneratorExpand)
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
      Js::Generators::AssetsGenerator.send(:include,Gen::JsAssetsGeneratorExpand)
      require 'rails/generators/css/assets/assets_generator'
      Css::Generators::AssetsGenerator.send(:include,Gen::CssAssetsGeneratorExpand)
      # #扩展Sass::Generators::ScaffoldBase，解决在设置--module= xx 参数后生成的scaffold.css.xx 不在指定目录下
      # require 'rails/generators/sass_scaffold'
      # Sass::Generators::ScaffoldBase.send(:include, Gen::SassScaffoldGeneratorExpand)

      #扩展Erb::Generators::ControllerGenerator 解决在设置--module= xx 参数后运行rails g controller命令在app/view/下生成一个xx空文件夹
      require 'rails/generators/erb/controller/controller_generator'
      Erb::Generators::ControllerGenerator.send(:include,Gen::ControllerGeneratorExpand)
    end

  end
end
