Ironmine::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
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
  #config.action_mailer.smtp_settings = {
	#	:address => "smtp.gmail.com",
	#	:port => 587,
	#	:domain => 'mail.google.com',
	#	:user_name => 'root.ironmine@gmail.com',
	#	:password => 'handhand',
	#	:authentication => 'plain',
	#	:enable_starttls_auto => true
  #}
  config.action_mailer.smtp_settings = {
		:address => "smtp.163.com",
		:port => 25,
		:domain => 'www.163.com',
		:user_name => 'rootironmine@163.com',
		:password => 'handhand',
		:authentication => :login
  }
  # config for receive mail
  config.irm.mail_receive_method = :imap
  config.irm.mail_receive_interval = '1m'
  #config.irm.mail_receive_imap = {
  #  :username => 'root.ironmine@gmail.com',
  #  :password => 'handhand',
  #  :host   => 'imap.gmail.com',
  #  :port     => 993,
  #  :ssl    => true
  #}
  config.irm.mail_receive_imap = {
    :username => 'rootironmine@163.com',
    :password => 'handhand',
    :host   => 'imap.163.com',
    :port     => 993,
    :ssl    => true
  }
  config.irm.mail_receive_pop = {
    :username => 'rootironmine@163.com',
    :password => 'handhand',
    :host   => 'pop3.163.com',
    :port     => 110
  }

  Paperclip.options[:command_path] = '/opt/local/bin'

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true
end

