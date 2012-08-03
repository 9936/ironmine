# Include hook code here
require File.dirname(__FILE__) + '/lib/show_exceptions'

ActionDispatch::ShowExceptions.send(:include,ShowExceptions)
