source 'http://rubygems.org'

gem 'rails', '3.1.1.rc1'

gem 'rake','0.9.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


#gem 'ruby-mysql'

#gem 'rack-mini-profiler'

gem 'liquid', '2.2.2',:require=>'liquid'

gem "daemons", '1.1.4'

gem "net-ldap", '0.2.2'

gem "spreadsheet", '0.6.5.9'

gem "rufus-scheduler", '2.0.10'

gem "paperclip", "2.4.1"

gem "delayed_job" , '2.1.4'

gem "event-calendar", '2.3.3', :require => "event_calendar"

gem 'ri_cal', '0.8.8'

gem 'hz2py', '0.0.4'

gem 'uuid' , '2.3.4'

gem 'sunspot_rails','1.3.3'
gem 'sunspot_solr', '1.3.3'
gem "sunspot_cell", '0.1.2'

#gem "sunspot", "1.2.1"
#gem "sunspot_rails", "1.2.1"

gem 'nokogiri', '1.5.0'

gem "mysql2", "~> 0.3.11"

gem 'sprockets','2.0.3'

gem 'yajl-ruby','1.1.0'

#Gems used to export data to pdf
gem 'wicked_pdf'
gem "wkhtmltopdf-binary"

# wiki
gem 'grit','2.5.0'
gem 'gollum' ,'2.1.0'

#解决blankslate 3.1.2 运行rake命令老式提示错误警告
gem 'blankslate', '2.1.2.4'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails' ,'2.1.1'
  gem 'jquery-rails', '1.0.19'
end





if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end