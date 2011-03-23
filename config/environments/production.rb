Ironmine::Application.configure do

#  # Settings specified here will take precedence over those in config/environment.rb
#
#  # The production environment is meant for finished, "live" apps.
#  # Code is not reloaded between requests
#  config.cache_classes = true
#
#  # Full error reports are disabled and caching is turned on
#  config.consider_all_requests_local       = false
#  config.action_controller.perform_caching = true
#
#  # Specifies the header that your server uses for sending files
#  config.action_dispatch.x_sendfile_header = "X-Sendfile"
#
#  # For nginx:
#  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
#
#  # If you have no front-end server that supports something like X-Sendfile,
#  # just comment this out and Rails will serve the files
#
#  # See everything in the log (default is :info)
##  config.log_level = :debug
#
#  # Use a different logger for distributed setups
##  config.logger = SyslogLogger.new
#
#  # Use a different cache store in production
#  # config.cache_store = :mem_cache_store
#
#  # Disable Rails's static asset server
#  # In production, Apache or nginx will already do this
#  config.serve_static_assets = false
#
#  # Enable serving of images, stylesheets, and javascripts from an asset server
#  # config.action_controller.asset_host = "http://assets.example.com"
#
#  # Disable delivery errors, bad email addresses will be ignored
#  # config.action_mailer.raise_delivery_errors = false
#
#  # Enable threaded mode
#  # config.threadsafe!
#
#  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
#  # the I18n.default_locale when a translation can not be found)
#  config.i18n.fallbacks = true
#
#  # Send deprecation notices to registered listeners
#  config.active_support.deprecation = :notify
#
#    # Don't care if the mailer can't send
#  config.action_mailer.raise_delivery_errors = false
#  config.action_mailer.delivery_method = :smtp
#  config.action_mailer.smtp_settings = {
#		:address => "smtp.gmail.com",
#		:port => 587,
#		:domain => 'mail.google.com',
#		:user_name => 'root.ironmine@gmail.com',
#		:password => 'handhand',
#		:authentication => 'plain',
#		:enable_starttls_auto => true
#  }

  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  #config.time_zone = 'Beijing'
  config.active_record.default_timezone = :local

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
		:address => "smtp.gmail.com",
		:port => 587,
		:domain => 'mail.google.com',
		:user_name => 'root.ironmine@gmail.com',
		:password => 'handhand',
		:authentication => 'plain',
		:enable_starttls_auto => true
  }

  Paperclip.options[:command_path] = '/usr/local/bin'
end
