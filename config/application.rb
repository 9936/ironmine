require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

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

    config.ironmine.javascript = ActiveSupport::OrderedOptions.new
    config.ironmine.css = ActiveSupport::OrderedOptions.new
    config.ironmine.javascript.source = {
        :jquery =>%w(jquery-1.6.4.min  locales/jquery-{locale} jquery-rails jquery-extend jquery-application jquery-colorbox-min),
        :jcrop => %w(jquery-crop),
        :jplugin => %w(jquery-plugin),
        :extjs=>%w(ext4-all ext-extend ext-application locales/ext-{locale}),
        :survey=>%w(survey),
        :datepicker=>%w(jquery-bigiframe jquery-datepicker locales/jquery-datepicker-{locale} jquery-datepicker-date),
        :waypoints => %w(jquery-waypoints),
        :video => %w(video),
        :jpolite => %w(jpolite/jquery-ui-jpolite.min jpolite/jpolite.core jpolite/jpolite.ext),
        :treeview => %w(jquery-treeview),
        :treeview_async => %w(jquery-treeview-async),
        :ace => %w(ace/ace ace/mode-html),
        :xheditor => %w(xheditor/xheditor-{locale})
    }
    config.ironmine.css.source = {
        :default =>%w(colorbox base button container form header icons layout other public sidebar table jmask),
        :application=>%w(),
        :setting=>%w(setting_base button container form header icons layout other public sidebar table jmask),
        :home=>%w(),
        :login=>%w(login),
        :common=>%w(login),
        :common_all=>%w(base button container form public),
        :jcrop=>%w(jcrop),
        :extjs=>%w(ext4-all ext4-cux),
        :datepicker=>%w(jquery-datepicker),
        :video => %w(video-js),
        :jpolite => %w(screen style),
        :treeview => %w(treeview),
        :autosaving => %w(auto-saving),
        :xheditor_plugin => %w(xheditor-plugin)
    }

    # config modules
    modules = Dir["#{config.root}/modules/*"].sort.collect{|i| File.basename(i).split("_").last if File.directory?(i)}.compact
    origin_values =  paths.dup
    modules.reverse.each do |module_name|
      paths.keys.each do |key|
        next unless paths[key].is_a?(Array)
        file_path ="modules/#{module_name}/#{origin_values[key][0]}"
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
