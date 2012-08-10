require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"

# 加载框架配置
require File.expand_path("../../lib/fwk/railtie", __FILE__)
# 加载各模块配置
# 忽略模块
module_ignore = []
if File.exists?("#{Rails.root}/modules/.ignore")
  module_ignore = File.open("#{Rails.root}/modules/.ignore", "rb").read.split(",").collect { |i| i if i.present? }.compact
end
Dir["#{File.expand_path('../..', __FILE__)}/modules/*"].sort.reverse.each do |file|
  m = File.basename(file).split("_").last
  next if module_ignore.include?(m)
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
    config.ironmine.languages = [:zh, :en]

    config.ironmine.jscss = {
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
        :markdown => {:css => ["markdown"]},
        :search => {:css => ["search"]}
    }
    # 自动对资源文件进行预编译
    config.ironmine.jscss.values.each do |asset|
      files = []

      asset[:css].each do |css|
        if css.to_s.include?("{locale}")
          config.ironmine.languages.each do |lang|
            files << css.to_s.gsub("{locale}", lang.to_s).to_s+".css"
          end
        else
          files << "#{css}.css"
        end
      end if asset[:css]
      asset[:js].each do |js|
        if js.to_s.include?("{locale}")
          config.ironmine.languages.each do |lang|
            files << js.to_s.gsub("{locale}", lang.to_s).to_s+".js"
          end
        else
          files << "#{js}.js"
        end
      end if asset[:js]
      config.assets.precompile += files
    end

    config.assets.precompile += ["report_types.css"]

    # 配置加载系统模块
    origin_values = config.paths.dup
    config.fwk.modules.each do |module_name|
      config.paths.keys.each do |key|
        next unless config.paths[key].is_a?(Array)
        file_path ="modules/#{config.fwk.module_mapping[module_name]}/#{origin_values[key][origin_values[key].length-1]}"
        real_file_path = "#{config.root}/#{file_path}"
        if File.exist?(real_file_path)
          if key.eql?('config/database')
            config.paths[key][0] = file_path
          else
            config.paths[key].insert(0, file_path)
          end
        end
        # 加载报表页面文件
        if key.eql?('app/views')
          report_view_path = "modules/#{config.fwk.module_mapping[module_name]}/reports/views"
          real_report_view_path = "#{config.root}/#{report_view_path}"
          if File.exist?(real_report_view_path)
            config.paths[key].insert(0, report_view_path)
          end
        end
      end

      # 加载报表文件
      report_path = "modules/#{config.fwk.module_mapping[module_name]}/reports/programs"
      real_report_path = "#{config.root}/#{report_path}"
      if File.exist?(real_report_path)
        config.autoload_paths += [real_report_path]
      end
    end

    # auto load class in lib and module lib
    config.autoload_paths += config.paths["lib"].expanded

    # auto load program report
    config.autoload_paths += %W(#{config.root}/program/report)


    # 自动生成时不生成asset
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
    end


  end
end
