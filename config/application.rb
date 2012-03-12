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
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/ext_lib #{config.root}/program/report)
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
    config.require_login_flag = false

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
        :ace => %w(ace/ace ace/mode-html)
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
        :autosaving => %w(auto-saving)
    }
  end
end
