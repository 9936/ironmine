source 'http://rubygems.org'

gem 'rails', '3.1.1.rc1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


#gem 'ruby-mysql'

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

gem "sunspot", "1.2.1"
gem "sunspot_rails", "1.2.1"

gem 'nokogiri', '1.5.0'
#gem 'composite_primary_keys', '=3.1.0'
#gem "rmmseg"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
#gem 'ferret'
  gem 'mysql2'
end

group :production do
#gem 'jk-ferret'
  gem 'mysql2'
end

group :macdev do
  gem 'mysql2'
end

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end