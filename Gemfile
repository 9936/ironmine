source 'http://rubygems.org'

gem 'rails','3.2.14'

gem 'rake','10.4.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'execjs', '2.5.0'
gem 'i18n', '0.6.9'
gem 'mustache', '0.99.5'
gem 'highline', '1.6.20'
gem 'net-ssh', '2.9.2'
gem 'test-unit'

gem 'passenger', '5.0.7'

gem 'pry'

gem 'liquid', '2.2.2',:require=>'liquid'

gem "daemons", '1.1.4'

gem "net-ldap", '0.2.2'

gem "spreadsheet", '0.6.5.9'
gem 'roo'

gem "rufus-scheduler", '2.0.10'

gem "paperclip", "2.7.5"

gem "delayed_job" , '2.1.4'

gem "event-calendar", '2.3.3', :require => "event_calendar"

gem 'ri_cal', '0.8.8'

gem 'hz2py', '0.0.4'

gem 'uuid' , '2.3.4'

gem 'macaddr','1.6.1'

gem 'sunspot_rails','1.3.3'
gem 'sunspot_solr', '1.3.3'
gem "sunspot_cell", '0.1.2'

gem 'nokogiri'

gem "mysql2", "~> 0.3.11"

gem 'sprockets','2.2.2'

gem 'yajl-ruby','1.1.0'

#Gems used to export data to pdf
gem 'wicked_pdf', '0.9.4'
#gem "wkhtmltopdf-binary", '0.9.9'

# wiki
gem 'grit','2.5.0'
gem 'gollum' ,'2.1.0'

#解决blankslate 3.1.2 运行rake命令老式提示错误警告
gem 'blankslate', '2.1.2.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.10.1'

  gem 'twitter-bootstrap-rails' ,'2.1.1'
  gem 'jquery-rails', '1.0.19'
end


gem "httparty", "~> 0.11.0"

# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano', :require => false


if RUBY_VERSION =~ /2.2/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end
