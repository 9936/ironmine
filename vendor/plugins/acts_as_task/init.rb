# Include hook code here
require File.dirname(__FILE__) + '/lib/acts_as_task'
ActiveRecord::Base.send(:include, Ironmine::Acts::Task)
ActionView::Base.send(:include,ActsAsTaskHelper)
